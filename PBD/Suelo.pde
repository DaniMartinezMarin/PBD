class Suelo {
  PVector location ;
  PVector pto1;
  PVector pto2;
  PVector plano;  
  PVector normal, uni, dist_col;
  float Kr = 0.45;
  float nv, delta_s, ang;
  PVector norm_plano, Norm, Tang, reposicionar; 
  PVector dif1, dif2;
  float distancia, modulo_plano, p1,p2, escalar_p1Plano, escalar_p2Plano;
  int id;
  
  Suelo(PVector l, float scale_px)
  {
    location = l.get();
    pto1 = new PVector(scale_px*location.x + 0.300,
                  -scale_px*location.y - 0.600001, 
                  scale_px*location.z);
    pto2 = new PVector(scale_px*location.x + 0.300,
                  -scale_px*location.y - 0.600002 , 
                  scale_px*location.z);    
    plano = PVector.sub(pto2, pto1);
    normal =  new PVector(0, -1, 0);
    normal.normalize();
    //println("punto1: " + pto1.x + "," +pto1.y + "," + pto1.z);
  }
  
  
  // Colisiones con el suelo (pto1, pto2)
  void checkCollisionsSuelo(Particle p)
  {
    
    // Aqui se calcula los vectores que va desde los puntos extremos del plano a la posicion de la pelota
    
    
    //println("punto1: " + pto1.x + "," +pto1.y + "," + pto1.z);
    dif1 = PVector.sub(pto1,p.location); 
    
   if(dif1.y >0){
        normal = normal.get();
        if(normal.dot(p.velocity)>0)
           normal.mult(-1);
        
        ang = PVector.angleBetween(p.velocity, plano);
        
    
        nv = normal.dot(p.velocity);
        Norm = PVector.mult(normal,nv);
        Tang = PVector.sub(p.velocity,Norm); 
        p.velocity = PVector.sub(Tang,PVector.mult(Norm,Kr));
        
      }
}
    
  
      
   

  void display(float scale_px){
    strokeWeight(1);
    rectMode(CENTER);
    fill(0);
    pushMatrix();
      translate(scale_px*location.x + 300,
                  -scale_px*location.y + 620, // OJO!! Se le cambia el signo, porque los px aumentan hacia abajo
                  scale_px*location.z);
      rotateX(PI/2);
      rect(0, 0, 10000, 10000);
    popMatrix();
  }
  
} 
  