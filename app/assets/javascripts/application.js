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
//= require bootstrap

$(document).ready(function(){
	$(".vote-up").live('click', function(){
		if ($(this).hasClass("disable")) {
			return false;
		}
		var url = $(this).attr('href') + ".json";
		var vote_up_links = $(this).parent('.vote').find('vote-up');
		var vote_links = $(this).parent('.vote').find('a');
		$.ajax({
		  url: url,
		  success: function(response){
		  	if (response.success) {
		  		vote_up_links.text("VCL(" + response.vote_up_count + ")")
		  		vote_links.addClass("disable");
		  	} else {
		  		alert('false');
		  	}
		  }
		});
		return false;
	});

	$(".vote-down").live('click', function(){
		if ($(this).hasClass("disable")) {
			return false;
		}
		var url = $(this).attr('href') + ".json";
		var vote_down_links = $(this).parent('.vote').find('.vote-down');
		var vote_links = $(this).parent('.vote').find('a');
		$.ajax({
			url: url,
			success: function(response){
				if (response.success){
					vote_down_links.text("Chem gio(" + response.vote_down_count +")")
					vote_links.addClass("disable");
				} else {
					alert('false');
				}
			}
		});
		return false;
	});

	$(".report-link").live('click', function(){
		var url = $(this).attr('href') + ".json";
		var report_count = $(this).siblings('span.report-count');
		var report_link = $(this);
		console.log(report_link);
		$.ajax({
			url: url,
			success: function(response){
				if (response.success){
					report_link.text("Report (" + response.reports_count + ")");
					report_link.addClass("disable");
				} else {
					alert('false');
				}
			}
		});
		return false;
	});	

	$(".favourite-link").live('click', function(){
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
				if (response.success){
					$(".comments").append(response.html);
					f[0].reset();
				} else {
					alert('false');
				}
			}
		});
		return false;
	});

	$(".view-all-comments").click(function(){
		var url = $(this).attr('href');
		var link = $(this);
		var comments = $(this).parent('.comments');
		$.ajax({
			data: { show: "all" },
			url: url,
			dataType: 'json',
			success: function(response){
				if (response.success){
					link.hide();
					comments.html(response.html);
				}
			}
		});
		return false;
	});

	$('#post_form').submit(function(){
		var url = $(this).attr('action') + '.json';
		var type = $(this).attr('method');
		var f = $(this);
		var text_area = $(this).children(".field").children("textarea");
		console.log(text_area);
		$.ajax({
			url: url,
			type: type,
			data: f.serialize(),
			success: function(response){
				if (response.success){
					$(".posts").prepend(response.html);
					// text_area.text("Post something ....");
					f[0].reset();
				} else {
					alert("false");
				}
			}
		});
		return false;
	});
});
