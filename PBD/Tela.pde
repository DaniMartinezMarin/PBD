PBDSystem crea_tela(float alto,
    float ancho,
    float dens,
    int n_alto,
    int n_ancho,
    float stiffness,
    float display_size){
   
  int N = n_alto*n_ancho;
  float masa = dens*alto*ancho;
  PBDSystem tela = new PBDSystem(N,masa/N);
  
  float dx = ancho/(n_ancho-1.0);
  float dy = alto/(n_alto-1.0);
  float d_diag = sqrt(dx*dx + dy*dy);

  
  int id = 0;
  for (int i = 0; i< n_ancho;i++){
    for(int j = 0; j< n_alto;j++){
      Particle p = tela.particles.get(id);
      p.location.set(dx*i,0,dy*j);
      p.display_size = display_size;

      id++;
    }
  }
  
  /*
  Creo restricciones de distancia. Aquí sólo se crean restricciones de estructura.
  Faltarían las de shear y las de bending.
  Las de bending habría que sustituirlas después por restricciones de bending.
  */
  id = 0;
  for (int i = 0; i< n_ancho;i++){
    for(int j = 0; j< n_alto;j++){
      println("id: "+id+" (i,j) = ("+i+","+j+")");
      Particle p = tela.particles.get(id);
      if(i>0){
        int idx = id - n_alto;      
        Particle px = tela.particles.get(idx);       
        Constraint c = new DistanceConstraint(p,px,dx,stiffness); 
        tela.add_constraint(c);
        println("Restricción creada: "+ id+"->"+idx);
        
        //restricciones shear
        if(j>0){
           int id_diag_x = id - (n_alto + 1);
           Particle px_diag = tela.particles.get(id_diag_x);
           Constraint c_diag = new DistanceConstraint(p,px_diag,d_diag,stiffness);
           tela.add_constraint(c_diag);
        }
        
        
      }

      if(j>0){
        int idy = id - 1;
        Particle py = tela.particles.get(idy);
        Constraint c = new DistanceConstraint(p,py,dy,stiffness);
        tela.add_constraint(c);
        println("Restricción creada: "+ id+"->"+idy);
        
        //restricciones shear
        if(i < n_ancho - 1){
          int id_diag_y = id + (n_alto - 1);
          Particle py_diag = tela.particles.get(id_diag_y);
          Constraint c_diag = new DistanceConstraint(p,py_diag,d_diag,stiffness);
          tela.add_constraint(c_diag);
        }
      }

      id++;
    }
  }
  
  
  
  // Fijamos dos esquinas
  /*
  id = n_alto-1;
  tela.particles.get(id).set_bloqueada(true); 
  
  id = N-1;
  tela.particles.get(id).set_bloqueada(true); 
  */
  
  
  
  //****************************creacion restricciones de bending ****************************************
  
  id = 0;
  float angle_best, 
        angle;
        
  Particle v_best;
  
  for(Particle p: tela.particles){
    ArrayList<Particle> particulas_vecinas = new ArrayList<Particle>();
    int ind1 = id + 1;
    int ind2 = id + n_alto;
    Particle p1 = tela.particles.get(ind1);
    Particle p2 = tela.particles.get(ind2);
    particulas_vecinas.add(p1);
    particulas_vecinas.add(p2);
    
    for(Particle i: particulas_vecinas){
       angle_best = 0;
       v_best = i;
       
      for(Particle j: particulas_vecinas){
         angle = (PVector.dot(PVector.sub(i.location, p.location),PVector.sub(j.location, p.location)))/ (PVector.sub(i.location, p.location).mag()* PVector.sub(j.location, p.location).mag());
         
         if (angle < angle_best){
           angle_best = angle;
           v_best = j;
         }
      }
      
      Constraint cbend = new BendingConstraint(i,v_best,p);
      tela.add_constraint_bending(cbend);
      }
    }
    
  return tela;
}