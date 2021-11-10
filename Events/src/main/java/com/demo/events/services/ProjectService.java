package com.demo.events.services;

import java.util.List;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

import com.demo.events.models.Comment;
import com.demo.events.models.Event;
import com.demo.events.models.User;
import com.demo.events.models.UserEvent;
import com.demo.events.repositories.CommentRepo;
import com.demo.events.repositories.EventRepo;
import com.demo.events.repositories.UserEventRepo;
import com.demo.events.repositories.UserRepo;

@Service
public class ProjectService {
	
	private final CommentRepo cR;
	private final UserRepo uR;
	private final EventRepo eR;
	private final UserEventRepo uER;
	
	public ProjectService(CommentRepo cR, UserRepo uR, EventRepo eR, UserEventRepo uER) {
		this.cR = cR;
		this.uR = uR;
		this.eR = eR;
		this.uER = uER;
	}
	
	public User registerUser(User user) {
		String hash = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
		user.setPassword(hash);
		return uR.save(user);
	}
	
	public boolean checkLogin(String email,String password) {
		User user = uR.findByEmail(email);
		if(user == null) {
			return false;
		}
		else {
			if(BCrypt.checkpw(password, user.getPassword())) {
				return true;
			}
			else {
				return false;
			}
		}
	}
	
	public User findByEmail(String email) {
		return uR.findByEmail(email);
	}
	
	public User getUserById(Long id) {
		return uR.findById(id).get();
	}
	
	
	public Event createEvent(Event event, Long id) {
		event.setUser(getUserById(id));
		return eR.save(event);
	}
	
	public List<Event> sameStateEvents(String state){
		return eR.findByStateContains(state);
	}
	
	public List<Event> outSideStateEvents(String state){
		return eR.findByStateNotContains(state);
	}
	
	public Event eventById(Long id) {
		if(eR.findById(id) != null) {
			return eR.findById(id).get();
		}
		else {
			return null;
		}
	}
	
	public void deleteEventById(Long id) {
		eR.deleteById(id);
	}
	
	public void updateEvent(Event event) {
		eR.save(event);
	
	}
	
	public UserEvent userJoinEvent(UserEvent join) {
		return uER.save(join);
	}
	
	public Iterable<UserEvent> joinedEvents() {
		return uER.findAll();
	}
	
	public void cancelJoin(UserEvent userEvent) {
		uER.delete(userEvent);
	}
	
	public UserEvent findJoinedEvent(Event event, User user) {
		return uER.findByEventAndUser(event, user);
	}
	
	public Comment addComment(Comment comment) {
		return cR.save(comment);
	}


	
	
	
}
