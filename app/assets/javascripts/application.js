// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require_self

$(document).ready(function(){
	$(".vote-up").click(function(){
		if ($(this).hasClass("disable")) {
			return false;
		}
		var url = $(this).attr('href') + ".json";
		var vote_up_count = $(this).siblings('span.vote-up-count');
		var vote_links = $(this).parent('.vote').find('.vote-link');
		$.ajax({
		  url: url,
		  success: function(response){
		  	if (response.success) {
		  		vote_up_count.text(response.vote_up_count);
		  		vote_links.addClass("disable");
		  	} else {
		  		alert('false');
		  	}
		  }
		});
		return false;
	});

	$(".vote-down").click(function(){
		if ($(this).hasClass("disable")) {
			return false;
		}
		var url = $(this).attr('href') + ".json";
		var vote_down_count = $(this).siblings('span.vote-down-count');
		var vote_links = $(this).parent('.vote').find('.vote-link');
		console.log(vote_down_count);
		$.ajax({
			url: url,
			success: function(response){
				if (response.success){
					vote_down_count.text(response.vote_down_count);
					vote_links.addClass("disable");
					console.log(response.vote_down_count);
				} else {
					alert('false');
				}
			}
		});
		return false;
	});

	// $("dsd").prepend(response.html)

	$(".report-link").click(function(){
		var url = $(this).attr('href') + ".json";
		var report_count = $(this).siblings('span.report-count');
		var report_link = $(this);
		console.log(report_link);
		$.ajax({
			url: url,
			success: function(response){
				if (response.success){
					report_count.text(response.reports_count);
					report_link.addClass("disable");
				} else {
					alert('false');
				}
			}
		});
		return false;
	});	

	$(".favourite-link").click(function(){
		var url = $(this).attr('href') + ".json";
		var favourite = $(this);
		$.ajax({
			url: url,
			success: function(response){
				if (response.success){
					favourite.text('Remove Favourite')
				} else {
					favourite.text('Favourite');
				}
			}
		});
		return false;
	});

	$("#comment_form").submit(function(){
		var url = $(this).attr('action') + ".json"; 
		var type = $(this).attr('method');
		var f = $(this);
		$.ajax({
			url: url,
			type: type,
			data: f.serialize(),
			success: function(response){
				console.log(response);
				if (response.success){
					$(".comments").append(response.html);
				} else {
					alert('false');
				}
			}
		});
		return false;
	});
});
