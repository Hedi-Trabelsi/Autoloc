package tn.esprit.autoloc.service;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import tn.esprit.autoloc.domain.Equipement;
import tn.esprit.autoloc.domain.Vehicule;
import tn.esprit.autoloc.repository.EquipementRepository;
import tn.esprit.autoloc.repository.VehiculeRepository;

import java.util.List;

@Service
@AllArgsConstructor
public class IEquipementServiceImp implements IEquipementService {

    private final EquipementRepository equipementRepository;
    private final VehiculeRepository vehiculeRepository;

    @Override
    public Equipement ajouterEquipement(Equipement equipement) {
        return equipementRepository.save(equipement);
    }

    @Override
    public Equipement modifierEquipement(Equipement equipement) {
        return equipementRepository.save(equipement);
    }

    @Override
    public Equipement getEquipementById(Long id) {
        return equipementRepository.findById(id).orElse(null);
    }

    @Override
    public void supprimerEquipement(Long id) {
        Equipement equipement = equipementRepository.findById(id).get();
        if (equipement.getVehicules() != null) {
            for (Vehicule vehicule : equipement.getVehicules()) {
                vehicule.getEquipements().remove(equipement);
                vehiculeRepository.save(vehicule);
            }
        }
        equipementRepository.deleteById(id);
    }

    @Override
    public List<Equipement> getAllEquipements() {
        return equipementRepository.findAll();
    }
}
