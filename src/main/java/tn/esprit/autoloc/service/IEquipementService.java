package tn.esprit.autoloc.service;

import tn.esprit.autoloc.domain.Equipement;

import java.util.List;

public interface IEquipementService {
    public Equipement ajouterEquipement(Equipement equipement);
    public Equipement modifierEquipement(Equipement equipement);
    public Equipement getEquipementById(Long id);
    public void supprimerEquipement(Long id);
    List<Equipement> getAllEquipements();
}
