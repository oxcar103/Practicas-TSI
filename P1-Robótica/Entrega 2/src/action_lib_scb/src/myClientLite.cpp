#include <ros/ros.h>
#include <move_base_msgs/MoveBaseAction.h>
#include <actionlib/client/simple_action_client.h>
#include "tf/transform_listener.h"
#include "costmap_2d/costmap_2d_ros.h"
#include <costmap_2d/costmap_2d.h>
#include <vector>
#include <math.h>

bool inicializado=false;
bool bloqueado=false;
bool bloqueado1=false;
bool terminado=false;
bool terminado1=false;
double x_ini,x_act;
double y_ini,y_act;
std::vector<std::pair<double,double> > huellas;
int tam=80;
int ind=0;
double x, y, theta;

typedef actionlib::SimpleActionClient<move_base_msgs::MoveBaseAction> MoveBaseClient;

double angulo(double x1,double y1,double x2,double y2){
	double mod1=sqrt(x1*x1+y1*y1);
	double mod2=sqrt(x2*x2+y2*y2);
	double esc=x1*x2+y1*y2;
	return acos(esc/(mod1*mod2));
}

std::pair<double,double> heuristica(costmap_2d::Costmap2DROS * costmap_ros,double height,double width,double resol){
	double x_vect=x_act-x;
	double y_vect=y_act-y;
	double mejorben=0;
	int xSol,ySol;
	double xw,yw;
	costmap_2d::Costmap2D *costmap;
     costmap = costmap_ros->getCostmap();
	for (int i=0 ;i < costmap->getSizeInCellsY() ;i++){
          for (int j= 0; j < costmap->getSizeInCellsX();j++){
          	  double benef=0;
              for (int y=0 ;y < costmap->getSizeInCellsY();y++){
				  for (int x= 0; x < costmap->getSizeInCellsX();x++){
			  		if(x!=i || y!=j){
			  			double dist=sqrt((x-i)*(x-i)+(y-j)*(y-j));
			  			benef+=1/((((double) costmap->getCost(x,y))+1)*dist);
			  		}else{
			  			benef+=2/((((double) costmap->getCost(x,y))+1));
			  		}
				      
				 }
			 }
			 xw=(i+0.5)*resol;
     		 yw=(j+0.5)*resol;
			 double x_vect2=xw+x_vect;
			 double y_vect2=yw+y_vect;
			 double ang=angulo(x_vect,y_vect,x_vect2,y_vect2);
			 benef*=ang;
			 if(benef>mejorben && costmap->getCost(i,j)<0.65*254){
			 	xSol=i;
			 	ySol=j;
			 	mejorben=benef;
			 }
          }
     }
     std::cout<<xSol<<","<<ySol<<std::endl;
     xw=(xSol+0.5)*resol;
     yw=(ySol+0.5)*resol;
     std::pair<double,double> res(x_act-width/2.0+xw,y_act+height/2.0-yw);
     return res;
     
}

//imprime en pantalla el contendio de un costmap
void printCostmap (costmap_2d::Costmap2DROS * costmap_ros) {
     //typedef basic_string<unsigned char> ustring;


     costmap_2d::Costmap2D *costmap;
     costmap = costmap_ros-> getCostmap();

     for (int y=0 ;y < costmap->getSizeInCellsY() ;y++){
          for (int x= 0; x < costmap->getSizeInCellsX();x++){
          		/*if(x==2 && y==3){
          			std::cout  << "x ";
          		}else*/
              		std::cout << (int) costmap->getCost(x,y) << " ";
            }
     	std::cout << "\n";
     }
}

void feedbackCBGoal0(const move_base_msgs::MoveBaseFeedbackConstPtr &feedback){
	x_act=feedback->base_position.pose.position.x;
	y_act=feedback->base_position.pose.position.y;
	if(!inicializado){
		ROS_INFO("Feedback (%f,%f,%f)",feedback->base_position.pose.position.x,feedback->base_position.pose.position.y,feedback->base_position.pose.orientation.w);
		x_ini=feedback->base_position.pose.position.x;
		y_ini=feedback->base_position.pose.position.y;
		inicializado=true;
	}else{
		//float distancia=(x_ini-feedback->base_position.pose.position.x)*(x_ini-feedback->base_position.pose.position.x)+(y_ini-feedback->base_position.pose.position.y)*(y_ini-feedback->base_position.pose.position.y);
		float distancia=(x-feedback->base_position.pose.position.x)*(x-feedback->base_position.pose.position.x)+(y-feedback->base_position.pose.position.y)*(y-feedback->base_position.pose.position.y);
		distancia=sqrt(distancia);
		ROS_INFO_THROTTLE(1,"Distancia: %f",distancia);
		
		if(huellas.size()<tam){
			huellas.push_back(std::pair<double,double> (feedback->base_position.pose.position.x,feedback->base_position.pose.position.y));
		}else{
			distancia=(huellas[ind].first-feedback->base_position.pose.position.x)*(huellas[ind].first-feedback->base_position.pose.position.x)+(huellas[ind].second-feedback->base_position.pose.position.y)*(huellas[ind].second-feedback->base_position.pose.position.y);
			distancia=sqrt(distancia);
			huellas[ind]=std::pair<double,double> (feedback->base_position.pose.position.x,feedback->base_position.pose.position.y);
			ind=(ind+1)%50;
			if(distancia<0.1){
				bloqueado=true;
			}
		}
	}
}
void feedbackCBGoal1(const move_base_msgs::MoveBaseFeedbackConstPtr &feedback){
	float distancia=(x_ini-feedback->base_position.pose.position.x)*(x_ini-feedback->base_position.pose.position.x)+(y_ini-feedback->base_position.pose.position.y)*(y_ini-feedback->base_position.pose.position.y);
	distancia=sqrt(distancia);
	ROS_INFO_THROTTLE(1,"Distancia 2: %f",distancia);
	
	if(huellas.size()<tam){
		huellas.push_back(std::pair<double,double> (feedback->base_position.pose.position.x,feedback->base_position.pose.position.y));
	}else{
		distancia=(huellas[ind].first-feedback->base_position.pose.position.x)*(huellas[ind].first-feedback->base_position.pose.position.x)+(huellas[ind].second-feedback->base_position.pose.position.y)*(huellas[ind].second-feedback->base_position.pose.position.y);
		distancia=sqrt(distancia);
		huellas[ind]=std::pair<double,double> (feedback->base_position.pose.position.x,feedback->base_position.pose.position.y);
		ind=(ind+1)%50;
		if(distancia<0.1){
			bloqueado1=true;
		}
	}
	
}
void doneCBGoal0(const actionlib::SimpleClientGoalState& estado, const move_base_msgs::MoveBaseResultConstPtr &resultado){
	  ROS_INFO("el estado termino en [%s]", estado.toString().c_str());
	  terminado=true;
  }
  void doneCBGoal1(const actionlib::SimpleClientGoalState& estado, const move_base_msgs::MoveBaseResultConstPtr &resultado){
	  ROS_INFO("el estado termino en [%s]", estado.toString().c_str());
	  terminado1=true;
  }
 void activeCBGoal0(){
 	ROS_INFO("El goal actual está activo");
 }

void spinThread()
{
  ros::spin();
}

int main(int argc, char** argv) {

  ros::init(argc,argv, "client_node");
  ros::NodeHandle nh;
  tf::TransformListener tf(ros::Duration(10));
  costmap_2d::Costmap2DROS* localcostmap = new costmap_2d::Costmap2DROS("local_costmap", tf);
  costmap_2d::Costmap2DROS* globalcostmap = new costmap_2d::Costmap2DROS("global_costmap", tf);
  //detener el funcionamiento de los costmaps hasta que estemos conectados con el servidor.

  localcostmap->pause();
  globalcostmap->pause();
 
  //crear el "action client"
  // true hace que el cliente haga "spin" en su propia hebra
  //Ojo: "move_base" puede ser cualquier string, pero hay que pensarlo como un "published topic". Por tanto, es importante que
  // el action server con el que va a comunicar tenga el mismo topic. E.d., al llamar a "as(n,string,....)" en el lado del
  // action server hay que usar el mismo string que en el cliente.
  MoveBaseClient ac("mi_move_base", true);  //<- poner "mi_move_base" para hacer mi propio action server.
  boost::thread spin_thread(&spinThread);
  //Esperar 60 sg. a que el action server esté levantado.
  ROS_INFO("Esperando a que el action server mi_move_base se levante");
  //si no se conecta, a los 60 sg. se mata el nodo.
  ac.waitForServer(ros::Duration(60));

  ROS_INFO("Conectado al servidor mi_move_base");
  
  localcostmap->start();
  globalcostmap->start();
  printCostmap(localcostmap);

  //Enviar un objetivo a move_base
	
  move_base_msgs::MoveBaseGoal goal;
   move_base_msgs::MoveBaseGoal goal2;
  goal2.target_pose.header.stamp =	ros::Time::now();
  goal.target_pose.header.frame_id = 	"map";
  goal.target_pose.header.stamp =	ros::Time::now();

  double res,height,width;
  nh.getParam("goal_x", x);
  nh.getParam("goal_y", y);
  nh.getParam("goal_theta", theta);
  nh.getParam("client_scb_node/local_costmap/resolution",res);
  nh.getParam("client_scb_node/local_costmap/width",width);
  nh.getParam("client_scb_node/local_costmap/height",height);
  
  ROS_INFO("La resolución del costmap local es %f", res);

  goal.target_pose.pose.position.x =	x;
  goal.target_pose.pose.position.y =	y;
  goal.target_pose.pose.orientation.w =	theta;

  ROS_INFO("Enviando el objetivo");
  ac.sendGoal(goal, &doneCBGoal0, &activeCBGoal0, &feedbackCBGoal0);

  ac.waitForResult(ros::Duration(1));
  //Esperar al retorno de la acción
  ROS_INFO("Esperando al resultado  de la acción");
  while(!terminado){
  	if(bloqueado){
  		ac.cancelGoal();
  		ac.waitForResult(ros::Duration(1));
  		bloqueado=false;
  		ind=0;
  		huellas.clear();
  		std::pair<double,double> nGoal;
  		nGoal=heuristica(localcostmap,height,width,res);
  		printCostmap(localcostmap);
  		std::cout<<x_act<<","<<y_act<<std::endl;
  		std::cout<<nGoal.first<<","<<nGoal.second<<std::endl;
  		goal2.target_pose.header.frame_id =localcostmap->getGlobalFrameID();
  		goal2.target_pose.pose.position.x =	nGoal.first;
	  	goal2.target_pose.pose.position.y =	nGoal.second;
	  	goal2.target_pose.pose.orientation.w =	1;
  		ac.sendGoal(goal2, &doneCBGoal1, &activeCBGoal0, &feedbackCBGoal1);
  		terminado1=false;
  		while(!terminado1){
		  	if(bloqueado1){
		  		ac.cancelGoal();
		  		ac.waitForResult(ros::Duration(1));
		  	}
		 }
		 if(!bloqueado1){
	  		goal.target_pose.pose.position.x =	x;
		    goal.target_pose.pose.position.y =	y;
		    goal.target_pose.pose.orientation.w =	theta;
		    ac.sendGoal(goal, &doneCBGoal0, &activeCBGoal0, &feedbackCBGoal0);
		    terminado=false;
		    ind=0;
  			huellas.clear();
  		}
  	}
  }


  if (ac.getState() == actionlib::SimpleClientGoalState::SUCCEEDED)
    ROS_INFO("¡¡ Objetivo alcanzado !!");
  else ROS_INFO("Se ha fallado por alguna razón.");
  
  ros::shutdown();
spin_thread.join();
  return 0;

}
