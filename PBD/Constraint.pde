
abstract class Constraint{

  ArrayList<Particle> particles;
  float stiffness;    // k en el paper de Muller
  float k_coef;       // k' en el paper de Muller
  float C;
  
  Constraint(){
    particles = new ArrayList<Particle>();
  }
  
  void  compute_k_coef(int n){
    k_coef = 1.0 - pow((1.0-stiffness),1.0/float(n));
    println("Fijamos "+n+" iteraciones   -->  k = "+stiffness+"    k' = "+k_coef+".");
  }

  abstract void proyecta_restriccion();
  abstract void display(float scale_px);
}

class DistanceConstraint extends Constraint{

  float d;
  
  DistanceConstraint(Particle p1,Particle p2,float dist,float k){
    super();
    d = dist;
    particles.add(p1);
    particles.add(p2);
    stiffness = k;
    k_coef = stiffness;
    C=0;

  }
  
  void proyecta_restriccion(){
    Particle part1 = particles.get(0); 
    Particle part2 = particles.get(1);
    
    PVector vd = PVector.sub(part1.location,part2.location);

    if(debug){
      println("PROYECTA: p1="+part1.location);
      println("PROYECTA: p2="+part2.location);
      println("PROYECTA: p1-p2="+vd);
    }
  
    float dist = vd.mag();
    if(debug)
      println("PROYECTA: dist="+dist+"   d0 = "+d);

    
    C = dist - d;
    
    float W = part1.w + part2.w;
    
    if( W*dist < 1e-5) // Si las partículas se solapan o están bloqueadas
      return;
    
    PVector delta = PVector.mult(vd,k_coef*C/(dist*W));
    
    if(debug){
      println("PROYECTA: C="+C+"   k'="+k_coef);
      println("PROYECTA: delta="+delta+"   W="+W);
      println("------");
    }
    
    part1.location.add(PVector.mult(delta, -part1.w ));
    part2.location.add(PVector.mult(delta,  part2.w ));
    
    
  }
  
  void display(float scale_px){
    PVector p1 = particles.get(0).location; 
    PVector p2 = particles.get(1).location; 
    strokeWeight(3);
    stroke(255,255*(1-abs(4*C/d)),255*(1-abs(4*C/d)));
    line(scale_px*p1.x, -scale_px*p1.y, scale_px*p1.z,  scale_px*p2.x, -scale_px*p2.y, scale_px*p2.z);
  };
  
}

class BendingConstraint extends Constraint{


  BendingConstraint(Particle p1,Particle p2, Particle p3){
    super();
    particles.add(p1);
    particles.add(p2);
    particles.add(p3);

  };
  
  void proyecta_restriccion(){
    /*
    Particle part1 = particles.get(0); 
    Particle part2 = particles.get(1);
    Particle part3 = particles.get(2);
    
    PVector vd = PVector.sub(part1.location,part2.location);

    
    float dist = vd.mag();
    if(debug)
      println("PROYECTA: dist="+dist+"   d0 = "+d);

    
    C = dist - d;
    
    float W = part1.w + part2.w;
    
    if( W*dist < 1e-5) // Si las partículas se solapan o están bloqueadas
      return;
    
    PVector delta = PVector.mult(vd,k_coef*C/(dist*W));
    
    if(debug){
      println("PROYECTA: C="+C+"   k'="+k_coef);
      println("PROYECTA: delta="+delta+"   W="+W);
      println("------");
    }
    
    part1.location.add(PVector.mult(delta, -part1.w ));
    part2.location.add(PVector.mult(delta,  part2.w ));
    
    */
  }
  
  void display(float scale_px){
    /*
    PVector p1 = particles.get(0).location; 
    PVector p2 = particles.get(1).location; 
    strokeWeight(3);
    stroke(255,255*(1-abs(4*C/d)),255*(1-abs(4*C/d)));
    line(scale_px*p1.x, -scale_px*p1.y, scale_px*p1.z,  scale_px*p2.x, -scale_px*p2.y, scale_px*p2.z);
 */ 
  };
  
}