package com.demo.events.controllers;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.demo.events.models.Comment;
import com.demo.events.models.Event;
import com.demo.events.models.User;
import com.demo.events.models.UserEvent;
import com.demo.events.services.ProjectService;
import com.demo.events.validator.UserValidator;

@Controller
public class ProjectController {
	
	private final ProjectService pS;
	private final UserValidator uV;

	public ProjectController(ProjectService pS, UserValidator uV) {
		this.pS = pS;
		this.uV = uV;
	}
	
	@GetMapping("/")
	public String loginRegister(@ModelAttribute("userReg")User register,HttpSession session) {
		if(session.isNew()) {
			session.setAttribute("login", false);
		}
		return"jsp/logReg.jsp";
	}
	
	@PostMapping("/register")
	public String registerProcess(@Valid @ModelAttribute("userReg")User uReg,BindingResult result,RedirectAttributes rA) {
		uV.validate(uReg, result);
		if(result.hasErrors()) {
			return"jsp/logReg.jsp";
		}
		else {
			pS.registerUser(uReg);
			rA.addFlashAttribute("success","<p class=\"alert alert-success\" role=\"alert\"> Registration Successful! You may now Log in. </p>");
			return"redirect:/";
		}
	}
	
	@PostMapping("/Login")
	public String loginProcess(@RequestParam("email")String email,@RequestParam("password")String password,HttpSession session,RedirectAttributes rA) {
		if(pS.checkLogin(email, password) == false) {
			rA.addFlashAttribute("error","<p class=\"alert alert-danger text-center\" role=\"alert\"> Invalid Credentials </p>");
			return "redirect:/";
		}
		else {
			session.setAttribute("login", true);
			session.setAttribute("user",pS.findByEmail(email).getId());
			return"redirect:/home";
			
		}
	}
	
	@GetMapping("/home")
		public String homePage(HttpSession session,Model model,@ModelAttribute("eventForm")Event event) {
			if((boolean)session.getAttribute("login") == true) {
				User user = pS.getUserById((Long)session.getAttribute("user"));
				model.addAttribute("user", pS.getUserById((Long)session.getAttribute("user")));
				model.addAttribute("inState",pS.sameStateEvents(user.getState()));
				model.addAttribute("outState",pS.outSideStateEvents(user.getState()));
				model.addAttribute("joinsEvent",pS.joinedEvents());
				return "jsp/home.jsp";
			}
			else {
				return"redirect:/";
			}
		}
	
	@PostMapping("/home")
	public String createEvent(@Valid @ModelAttribute("eventForm")Event event,BindingResult result,HttpSession session,Model model) {
		if(result.hasErrors()) {
			model.addAttribute("user", pS.getUserById((Long)session.getAttribute("user")));
			User user = pS.getUserById((Long)session.getAttribute("user"));
			model.addAttribute("user", pS.getUserById((Long)session.getAttribute("user")));
			model.addAttribute("inState",pS.sameStateEvents(user.getState()));
			model.addAttribute("outState",pS.outSideStateEvents(user.getState()));
			return"jsp/home.jsp";
		}
		else {
			Event newEvent = pS.createEvent(event,(Long) session.getAttribute("user"));
			return"redirect:/events/"+newEvent.getId();
		}
	}
	
	@GetMapping("/events/{eventId}")
	public String eventInfo(@PathVariable("eventId")Long eId,Model model,HttpSession session,@ModelAttribute("addComment")Comment comment) {
		if((boolean)session.getAttribute("login") == true) {
			model.addAttribute("event",pS.eventById(eId));
			model.addAttribute("user",pS.getUserById((Long)session.getAttribute("user")));
			return "jsp/eventInfo.jsp";
		}
		else {
			return "redirect:/";
		}
		
	}
	
	@PostMapping("/events/{eventId}")
	public String addComment(@PathVariable("eventId")Long eId,HttpSession session,@Valid @ModelAttribute("addComment")Comment comment,BindingResult result,Model model) {
		if(result.hasErrors()) {
			if((boolean)session.getAttribute("login") == true) {
				model.addAttribute("event",pS.eventById(eId));
				model.addAttribute("user",pS.getUserById((Long)session.getAttribute("user")));
				return "jsp/eventInfo.jsp";
			}
			else {
				return "redirect:/";
			}
		}
		else {
			User user = pS.getUserById((Long)session.getAttribute("user"));
			comment.setUser(user);
			comment.setEvent(pS.eventById(eId));
			pS.addComment(comment);
			return "redirect:/events/"+eId;
		}
	}
	
	@DeleteMapping("/home/{eventId}")
	public String deleteEvent(@PathVariable("eventId")Long eId,@RequestParam("userId")Long uId) {
		Event event = pS.eventById(eId);
		User user = pS.getUserById(uId);
		
		if(event.getUser().getId() == user.getId()) {
			pS.deleteEventById(eId);
			return"redirect:/home";
		}
		else {
			return"redirect:/logout";
		}
	}
	
	@GetMapping("home/edit/{eventId}")
	public String editEvent(@ModelAttribute("event")Event event,@PathVariable("eventId")Long id,Model model,HttpSession session) {
		
		if((boolean)session.getAttribute("login") == true) {
			model.addAttribute("event",pS.eventById(id));
			return"jsp/editEvent.jsp";
		}
		else {
			return"redirect:/";
		}
	}
	
	@PutMapping("home/{eventId}")
	public String updateEvent(@Valid @ModelAttribute("event")Event event,BindingResult result,@PathVariable("eventId")Long id,Model model, HttpSession session) {
		User user = pS.getUserById((Long)session.getAttribute("user"));
		if(pS.eventById(id).getUser().getId() == user.getId() ) {
			if(result.hasErrors()) {
				model.addAttribute("event",pS.eventById(id));
				return"jsp/editEvent.jsp";
			}
			else {
				event.setId(id);
				event.setUser(user);
				pS.updateEvent(event);
				return"redirect:/home";
			}
			
		}
		else {
			return"redirect:/";
		}
	}
	
	@PostMapping("/home/join")
	public String joinEvent (@Valid @ModelAttribute("userEvent")UserEvent join,BindingResult result,@RequestParam("event")Long event, @RequestParam("user")Long user) {
		if(result.hasErrors()) {
			return"jsp/home.jsp";
		}
		else {
			join.setUser(pS.getUserById(user));
			join.setEvent(pS.eventById(event));
			pS.userJoinEvent(join);
			return"redirect:/home";
		}
	}
	
	@DeleteMapping("/home/cancel")
	public String cancelJoin(@RequestParam("userId")Long uId,@RequestParam("eventId")Long eId) {
		User user = pS.getUserById(uId);
		Event event = pS.eventById(eId);
		UserEvent cancel = pS.findJoinedEvent(event, user);
		pS.cancelJoin(cancel);
		return"redirect:/home";
	}
	
	
	
	
	
	
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return"redirect:/";
	}
	
	
}
