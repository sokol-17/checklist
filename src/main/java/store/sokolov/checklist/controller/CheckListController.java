package store.sokolov.checklist.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import store.sokolov.checklist.core.CheckList;
import store.sokolov.checklist.service.ICheckListService;

import java.util.List;

@RestController
@RequestMapping(value = "/checklists")
public class CheckListController {
    private ICheckListService checkListService;

    @Autowired
    public CheckListController(ICheckListService checkListService) {
        this.checkListService = checkListService;
    }

    @GetMapping
    public List<CheckList> getCheckLists() {
        List<CheckList> checkLists = checkListService.getAllCheckLists();
        return checkLists;
    }
}
