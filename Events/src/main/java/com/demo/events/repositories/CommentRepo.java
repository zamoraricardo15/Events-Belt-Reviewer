package com.demo.events.repositories;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.demo.events.models.Comment;

@Repository
public interface CommentRepo extends CrudRepository<Comment,Long> {

}
