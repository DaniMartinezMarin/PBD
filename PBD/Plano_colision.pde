class Plano_colision{
  PVector pto1;
  PVector pto2;
  PVector plano;  
  PVector normal, uni, dist_col;
  float Kr = 0.45;
  float nv, delta_s, ang;
  PVector norm_plano, Norm, Tang, reposicionar; 
  PVector dif1, dif2;
  float distancia, modulo_plano, p1,p2, escalar_p1Plano, escalar_p2Plano;
  
  Plano_colision(PVector n)
  {
    normal = n;
    plano =  new PVector(-normal.y, normal.x);
    normal.normalize();
  }
  
  // Colisiones con el plano (pto1, pto2)
  void checkCollisions(Particle p)
  {
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