package com.demo.events.repositories;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.demo.events.models.Event;
import com.demo.events.models.User;
import com.demo.events.models.UserEvent;

@Repository
public interface UserEventRepo extends CrudRepository<UserEvent,Long> {
	List<UserEvent> findByEventContains(Event event);
	UserEvent findByEventAndUser(Event event, User user);
	
}
