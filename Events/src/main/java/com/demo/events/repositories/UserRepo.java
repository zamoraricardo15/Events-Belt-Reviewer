package com.demo.events.repositories;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.demo.events.models.User;

@Repository
public interface UserRepo extends CrudRepository<User,Long> {
	User findByEmail(String email);
}
