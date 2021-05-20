//**********************************************************
//--- Pour plus d'informations sur les fonctions suivantes,
//--- N'hésitez pas à consulter ma série de tutoriels
//--- https://youtube.com/playlist?list=PLf_pkTl38qfj6UHrbo_KwQEAvQXU8HsVJ
//__________________________________________________________

//**********************************************************
//--- Fonction pour exécuter le gravity turn
//__________________________________________________________
function gravityTurn{
  parameter altitudeCible, pitchAngle.
  local directionTilt is heading(90, pitchAngle) + R(0,0,myRoll()).
  lock steering to directionTilt.
  wait until vAng(facing:vector,directionTilt:vector) < 1.
  wait until vAng(srfPrograde:vector, up:vector) > vAng(up:vector, facing:vector).
  lock steering to heading(90, 90 - vAng(up:vector, srfPrograde:vector)) + R(0,0,myRoll()).
  wait until navMode = "orbit" or apoapsis >= 0.98*altitudeCible.
  lock steering to heading(90, 90 - vAng(up:vector, Prograde:vector)) + R(0,0,myRoll()).
  wait until apoapsis >= altitudeCible.
  lock throttle to 0.
  rcs on.
  wait 0.1.
  until ship:altitude >= body:atm:height - 500 {
    // on warp ici car l'apoapsis peut être atteinte très vite
    // alors que le vaisseau est encore a une faible altitude
    set warp to 3. 
  }
  set warp to 0.
}


//**********************************************************
//--- Pour éviter la rotation du vaisseau s'il n'est pas orienté vers l'est.
//__________________________________________________________

// Si vaisseau tourné vers le nord : ship:facing:roll ~ 180 
// Si vaisseau tourné vers l'est : ship:facing:roll ~ 270
function myRoll {
  local actualRoll is ship:facing:roll.
  local finalRoll is round(actualRoll - 270, 0).
  return finalRoll.
}


//**********************************************************
//--- Fonction pour exécuter une manoeuvre
//--- ATTENTION : le noeud de manoeuvre doit exister !
//--- ATTENTION : fonction non optimale lorsque deux étages sont nécessaires à la manoeuvre.
//__________________________________________________________
function executerManoeuvre {
  local noeud is nextNode.
  lock steering to noeud:burnVector.

  local max_acc is ship:maxthrust/ship:mass.
  local burn_duration is noeud:deltav:mag/max_acc.

  warpTo(time:seconds + noeud:eta - (burn_duration/2 + 30)).

  wait until noeud:eta <= (burn_duration/2).

  local tset is 0.
  lock throttle to tset.

  local done is False.
  local dv0 is noeud:deltav.

  until done
  {
    if ship:maxthrust <= 0 {
      stage.
      wait until stage:ready.
    }
    else {
      set max_acc to ship:maxthrust/ship:mass.
      set tset to min(noeud:deltav:mag/max_acc, 1).

      if vdot(dv0, noeud:deltav) < 0 {lock throttle to 0. break.}

      if noeud:deltav:mag < 0.1 {
        wait until vdot(dv0, noeud:deltav) < 0.5.
        lock throttle to 0.
        set done to True.
      }
    }
  }
  unlock steering.
  unlock throttle.
  wait 1.

  remove noeud.
  lock steering to prograde.
}

//**********************************************************
//--- Fonction pour circulariser une orbite
//--- Nécessite fonction transfertHohmann (cf ci-dessous)
//__________________________________________________________
function circularisation {
  parameter ApPe.
  local deltaV is 0.
  local noeudCirc is node(0, 0, 0, 0).

  if ApPe = "AP" {
    set deltaV to transfertHohmann(ship:orbit:apoapsis, ship:orbit:apoapsis).
    set noeudCirc to node(time:seconds + ETA:apoapsis, 0,0, deltaV).
  }
  else {
    set deltaV to transfertHohmann(ship:orbit:periapsis, ship:orbit:periapsis).
    set noeudCirc to node(time:seconds + ETA:periapsis, 0,0, deltaV).
  }
  add noeudCirc.
}

//**********************************************************
//--- Fonction pour calculer le delta-V nécessaire pour un changement d'orbite
//--- techniquement, cette fonction ne réalise pas exactement un transfert de Hohmann
//--- Nécessite la fonction calculerVitesse (cf ci-dessous)
//__________________________________________________________
function transfertHohmann {
  parameter altitudeVaisseau, altitudeCible.
  local vitesseInitiale is 0.
  local vitesseFinale is 0.
  local deltaV is 0.

  set vitesseInitiale to calculerVitesse(ship:orbit:periapsis, ship:orbit:apoapsis, altitudeVaisseau).

  if altitudeVaisseau < altitudeCible {
    set vitesseFinale to calculerVitesse(altitudeVaisseau, altitudeCible, altitudeVaisseau).
  }
  else {
    set vitesseFinale to calculerVitesse(altitudeCible, altitudeVaisseau, altitudeVaisseau).
  }

  set deltaV to vitesseFinale - vitesseInitiale.
  return deltaV.
}

//**********************************************************
//--- Fonction pour calculer la vitesse du craft
//--- en fonction de sa position et des caractéristiques de l'orbite
//__________________________________________________________
global function calculerVitesse {
  parameter peri, apo, altitudeVaisseau.
  
  local rayon is body:radius.
  local RV is rayon + altitudeVaisseau.
  local RP is rayon + peri.
  local RA is rayon + apo.
  local DGA is (RA + RP) / 2.

  return sqrt(body:mu * (2/RV - 1/DGA)).
}