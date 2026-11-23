package tn.esprit.autoloc.service;

import tn.esprit.autoloc.domain.Employe;

import java.util.List;

public interface IEmployeService {
    Employe ajouterEmploye(Employe employe);
    Employe modifierEmploye(Employe employe);
    Employe getEmployeById(Long id);
    List<Employe> getAllEmployes();
    void supprimerEmployeByID(Long id);
    Employe desaffecterAgence(Long idEmploye);
    Employe affectAgence(Long idEmploye, Long idAgence);
}
