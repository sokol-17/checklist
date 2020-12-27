package store.sokolov.checklist.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import store.sokolov.checklist.core.CheckList;

@Repository
public interface CheckListDao extends JpaRepository<CheckList, Long> {
}
