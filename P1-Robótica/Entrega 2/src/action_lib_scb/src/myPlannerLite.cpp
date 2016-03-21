#include "myPlannerLite.h"
#include "geometry_msgs/Twist.h"
#include <tf/transform_datatypes.h> //para transformar quaternions en ángulos, necesario en odomCallBack

double signo(double valor){
	if (valor > 0) return 1;
	else if (valor < 0) return -1;
	else return 0;
}

LocalPlanner::LocalPlanner()
{

    CAMPOATT.radius = 0.01; CAMPOATT.spread = 3.5; CAMPOATT.intens = 0.05; //Parámetros de configuración (radio, spread, alpha) del campo actractivo.
    CAMPOREP.radius = 0.35; CAMPOREP.spread = 0.7; CAMPOREP.intens = 0.01;//Parámetros de configuración (radio, spread, beta)del campo repulsivo.
    posGoal.x = posGoal.y = 0;  //Posición del objetivo
    pos.x = pos.y = 0;      //Posición actual
    yaw =0;     //Angulo (en radianes) de orientación del robot
    deltaGoal.x = deltaGoal.y = 0;//Componente del campo atractivo
    deltaObst.x = deltaObst.y = 0;//Componente del campo repulsivo (para todos los obstáculos)
    delta.x = delta.y = 0;    //Componente total
    v_angular = v_lineal = 0; //velocidad angular

	// Advertise a new publisher for the simulated robot's velocity command topic
	commandPub = node.advertise<geometry_msgs::Twist>("cmd_vel", 10);

	// Subscribe to the simulated robot's laser scan topic
	laserSub = node.subscribe("base_scan", 1, &LocalPlanner::scanCallBack, this);
    odomSub =  node.subscribe("base_pose_ground_truth", 1, &LocalPlanner::odomCallBack, this);

}

void LocalPlanner::odomCallBack(const nav_msgs::Odometry::ConstPtr& msg)
{
    //obtengo la posición
    double xPos=msg->pose.pose.position.x;
    double yPos=msg->pose.pose.position.y;
    //la asigno a LocalPlanner::pos
    pos.x = xPos;
    pos.y = yPos;

    //también la guardo en LocalPlanner::odometria
    odometria.pose.pose.position.x = xPos;
    odometria.pose.pose.position.y = yPos;

    //get Quaternion anglular information
    double x=msg->pose.pose.orientation.x;
    double y=msg->pose.pose.orientation.y;
    double z=msg->pose.pose.orientation.z;
    double w=msg->pose.pose.orientation.w;
    //la guardo en la odometría
    odometria.pose.pose.orientation.x = x;
    odometria.pose.pose.orientation.y = y;
    odometria.pose.pose.orientation.z = z;
    odometria.pose.pose.orientation.w = w;

    //convierto el quaternion en radianes y guardo el yaw en LocalPlanner::yaw
    yaw=atan2(2*(y*x+w*z),w*w+x*x-y*y-z*z);
    ROS_INFO("POSE: %f %f %f",xPos,yPos,yaw);
};

void LocalPlanner::setDeltaAtractivo() {

//Calcula el componente atractivo del campo de potencial
    double d = distancia(posGoal, pos);
    double theta = atan2(posGoal.y - pos.y, posGoal.x - pos.x);
    if (d-CAMPOATT.radius < TOLERANCIA){
        deltaGoal.x = deltaGoal.y = 0;
        return;
        }
    if ( (CAMPOATT.radius <= d) and (d <= (CAMPOATT.spread + CAMPOATT.radius ))){
        deltaGoal.x = CAMPOATT.intens *(d - CAMPOATT.radius)*cos(theta);
        deltaGoal.y = CAMPOATT.intens *(d - CAMPOATT.radius)*sin(theta);
        return;
    }
    if (d > (CAMPOATT.spread + CAMPOATT.radius)){
        deltaGoal.x = CAMPOATT.intens*CAMPOATT.spread*cos(theta);
        deltaGoal.y = CAMPOATT.intens*CAMPOATT.spread*sin(theta);
        return;
    }

}

void LocalPlanner::getOneDeltaRepulsivo(Tupla posObst, Tupla &deltaO){
// recibe una posición de un obstáculo y calcula el componente repulsivo para ese obstáculo.
// Devuelve los valores en deltaO.x y deltaO.y
    double d = distancia(posObst, pos);
    double theta = atan2(posObst.y - pos.y, posObst.x - pos.x);
    
    if (d - CAMPOREP.radius < TOLERANCIA){
        deltaO.x = -signo(cos(theta))*100;
        deltaO.y = -signo(sin(theta))*100;
        return;
        }
    if ( (CAMPOREP.radius <= d) and (d <= (CAMPOREP.spread + CAMPOREP.radius ))){
        deltaO.x = -CAMPOREP.intens *(CAMPOREP.spread + CAMPOREP.radius - d)*cos(theta);
        deltaO.y = -CAMPOREP.intens *(CAMPOREP.spread + CAMPOREP.radius - d)*sin(theta);
        return;
    }
    if (d > (CAMPOREP.spread + CAMPOREP.radius)){
        deltaO.x = deltaO.y = 0;
        return;
    }
}

void LocalPlanner::setTotalRepulsivo(){
//Calcula la componente total repulsiva como suma de las componentes repulsivas para cada obstáculo.
   deltaObst.x = deltaObst.y = 0;
   Tupla deltaOactual;
   
   for(int i = 0; i < posObs.size(); i++){
		getOneDeltaRepulsivo(posObs[i], deltaOactual);
		deltaObst.x += deltaOactual.x;
		deltaObst.y += deltaOactual.y;
	}
}

void LocalPlanner::scanCallBack(const sensor_msgs::LaserScan::ConstPtr& scan)
{
	// Find the closest range between the defined minimum and maximum angles
	int minIndex = ceil((MIN_SCAN_ANGLE_RAD - scan->angle_min) / scan->angle_increment);
	int maxIndex = floor((MAX_SCAN_ANGLE_RAD - scan->angle_min) / scan->angle_increment);

    //limpio el vector de posiciones de obstaculos
    if (posObs.size() > 0)
        posObs.clear();

    //bearing indica el ángulo de cada muestra
    double bearing = MIN_SCAN_ANGLE_RAD;

    //calculamos la posición de cada obstáculo dada por la muestra láser.
	float closestRange = scan->ranges[minIndex];
	for (int currIndex = minIndex + 1; currIndex <= maxIndex; currIndex++) {
		Tupla obstaculo;
		obstaculo.x =pos.x + scan->ranges[currIndex]*cos(yaw+bearing);
		obstaculo.y =pos.y + scan->ranges[currIndex]*sin(yaw+bearing);
		//ROS_INFO("Obstaculo %d en posición (%f,%f)",currIndex,obstaculo.x, obstaculo.y);
		posObs.push_back(obstaculo);
		bearing += scan->angle_increment;
		}
	}

double normalize(double angle) {
//normaliza un ángulo al intervalo [-PI, PI]
    angle = fmod(angle + M_PI, 2*M_PI);
    if (angle < 0)
        angle += 2*M_PI;
    return angle - M_PI;
}
void LocalPlanner::setv_Angular(){
//calcula la velocidad angular
    double angulo = atan2(delta.y, delta.x);
    double diferencia_normalizada = normalize(angulo-yaw);


    if ((0 <= diferencia_normalizada) and (diferencia_normalizada <= M_PI))
        if (diferencia_normalizada > V_ANGULAR_CTE)
            v_angular = V_ANGULAR_CTE;
        else v_angular = (diferencia_normalizada < EPSILON_ANGULAR)? 0: diferencia_normalizada;
    else
        if (diferencia_normalizada < (-1)*V_ANGULAR_CTE)
            v_angular = (-1)*V_ANGULAR_CTE;
        else v_angular = (diferencia_normalizada > (-1)*EPSILON_ANGULAR)? 0: diferencia_normalizada;


}
void LocalPlanner::setv_Lineal(){
//calcula la velocidad lineal
    if (signo(v_angular)*v_angular < 0.1)
    	v_lineal =  sqrt(delta.x*delta.x + delta.y*delta.y);
    else
    	v_lineal = 0;
    }
bool LocalPlanner::goalAchieved(){

//determina que el objetivo se ha alcanzado cuando ambas velocidades son 0.
    return (v_angular == 0 and v_lineal == 0);
    }

