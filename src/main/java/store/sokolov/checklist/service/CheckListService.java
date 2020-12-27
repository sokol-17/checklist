package store.sokolov.checklist.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import store.sokolov.checklist.core.CheckList;
import store.sokolov.checklist.dao.CheckListDao;

import java.util.List;

@Service
public class CheckListService implements ICheckListService {
    private CheckListDao checkListDao;

    @Autowired
    public CheckListService(CheckListDao checkListDao) {
        this.checkListDao = checkListDao;
    }

    @Override
    public List<CheckList> getAllCheckLists() {
        List<CheckList> checkLists = checkListDao.findAll();
        return checkLists;
    }
}
