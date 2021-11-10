package com.demo.events.repositories;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.demo.events.models.Event;

@Repository
public interface EventRepo extends CrudRepository<Event,Long> {
	List<Event> findByStateContains(String state);
	List<Event> findByStateNotContains(String state);

}
