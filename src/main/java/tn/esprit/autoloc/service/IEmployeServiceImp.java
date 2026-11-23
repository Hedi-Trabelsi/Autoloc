package tn.esprit.autoloc.service;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import tn.esprit.autoloc.domain.Agence;
import tn.esprit.autoloc.domain.Employe;
import tn.esprit.autoloc.repository.AgenceRepository;
import tn.esprit.autoloc.repository.EmployeRepository;

import java.util.List;

@Service
@AllArgsConstructor
public class IEmployeServiceImp implements IEmployeService {

    private final EmployeRepository employeRepository;
    private final AgenceRepository agenceRepository;

    @Override
    public Employe ajouterEmploye(Employe employe) {
        return employeRepository.save(employe);
    }

    @Override
    public Employe modifierEmploye(Employe employe) {
        return employeRepository.save(employe);
    }

    @Override
    public Employe getEmployeById(Long id) {
        return employeRepository.findById(id).orElse(null);
    }

    @Override
    public List<Employe> getAllEmployes() {
        return employeRepository.findAll();
    }

    @Override
    public void supprimerEmployeByID(Long id) {
        employeRepository.deleteById(id);
    }

    @Override
    public Employe desaffecterAgence(Long idEmploye) {
        Employe e = employeRepository.findById(idEmploye).get();
        e.setAgence(null);
        return employeRepository.save(e);
    }

    @Override
    public Employe affectAgence(Long idEmploye, Long idAgence) {
        Employe e = employeRepository.findById(idEmploye).get();
        Agence a = agenceRepository.findById(idAgence).get();
        e.setAgence(a);
        return employeRepository.save(e);
    }
}
