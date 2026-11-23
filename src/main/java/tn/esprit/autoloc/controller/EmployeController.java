package tn.esprit.autoloc.controller;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import tn.esprit.autoloc.domain.Employe;
import tn.esprit.autoloc.service.IEmployeService;

@RestController
@AllArgsConstructor
@RequestMapping("/employes")
public class EmployeController {
    private final IEmployeService employeService;

    @PutMapping("/desaffecterEmploye/{idEmploye}")
    public Employe desaffecterEmploye(@PathVariable Long idEmploye) {
        return employeService.desaffecterAgence(idEmploye);
    }

    @PutMapping("/affecterAgence/{idEmploye}/{idAgence}")
    public Employe affecterAgence(@PathVariable Long idEmploye, @PathVariable Long idAgence) {
        return employeService.affectAgence(idEmploye, idAgence);
    }
}
