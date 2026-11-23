package tn.esprit.autoloc.service;

import tn.esprit.autoloc.domain.Vehicule;

import java.util.List;

public interface IVehiculeService {
    public Vehicule ajouterVehicule(Vehicule vehicule);
    public Vehicule modifierVehicule(Vehicule vehicule);
    public Vehicule getVehiculeById(Long id);
    public void supprimerVehicule(Long id);
    List<Vehicule> getAllVehicules();
}
