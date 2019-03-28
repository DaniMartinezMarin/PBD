class ObjetoColision {

  PVector acceleration;
  PVector force;
  PVector velocity;
  PVector location;
  PVector last_location;
  PVector vec_distancia, normal, plano, uni, distancia_colision, reposicionar, dist_col;
  float masa, distancia, escalar_p1Plano;
  float w, p1;
  float Kr = 0.9;
  float nv, delta_s, ang;
  PVector norm_plano, Norm, Tang; 
  
  boolean bloqueada;
  
  float display_size;
  float radio = 150;

  ObjetoColision(PVector l, PVector v, float ma) {
    acceleration = new PVector(0.0f,0.0f,0.0f);
    force = new PVector(0.0f,0.0f,0.0f);
    velocity = v.get();
    location = l.get();
    
    masa = ma;
    w = 1.0f/ma;   
    
    display_size = 0.1;
  }

  void set_bloqueada(boolean bl){
    bloqueada = true;
    w = 0;
    masa = Float.POSITIVE_INFINITY;
  }

  void update_pbd_vel(float dt){
   velocity = PVector.sub(location, last_location).div(dt);
  }

  // Method to update location
  void update(float dt) {

    //--->actualizar la aceleracion de la particula con la fuerza actual
    acceleration.add(force.mult(w));
    
    //--->guardamos posicion anterior, para PBD 
    last_location = location.copy();

    //---> Predicción de PBD
    //---> Utilizar euler semiimplicito para calcular velocidad y posicion
    velocity.add(acceleration.mult(dt));
    location.add(velocity.mult(dt)); 
    
    //---> Limpieza de fuerzas y aceleraciones
    acceleration = new PVector(0.0f,0.0f,0.0f);
    force = new PVector(0.0f,0.0f,0.0f);
  }
  
  PVector getLocation(){
    return location;
  }

  PVector getLastLocation(){
    return last_location;
  }

  void display(float scale_px){
    strokeWeight(1);
    stroke(125);
    pushMatrix();
      fill(220);
            translate(scale_px*location.x,
                  -scale_px*location.y, // OJO!! Se le cambia el signo, porque los px aumentan hacia abajo
                  scale_px*location.z);
    sphereDetail(12);
    sphere(radio);
    popMatrix();

      
  }
  
  float project(PVector v , PVector d){
    
        float m = 0;
        
        if(v.mag() == 0 && d.mag() == 0)
        { m = 0;
        }else{
          m = PVector.dot(v,d) /  d.mag();
        }
        d.normalize();
        
        return m;
    
  }
  
}