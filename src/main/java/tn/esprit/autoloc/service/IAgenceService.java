package tn.esprit.autoloc.service;

import tn.esprit.autoloc.domain.Agence;

import java.util.List;

public interface IAgenceService {
    public Agence ajouterAgence(Agence agence);
    public Agence modifierAgence(Agence agence);
    public Agence getAgenceById(Long id);
    public void supprimerAgence(Long id);
    List<Agence> getAllAgences();
}
