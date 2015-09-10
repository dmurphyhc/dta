// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/basic
//
// Required by Blacklight
//= require blacklight/blacklight
//= require_tree .

$(function() {
	$('#add_topic').click(function() {
		$("#topic").append('<input id="item_subject__topic_" class="topic_addition field_addition" type="text" style="width:600px;" name="item[subject][][topic][]">');
		return false;
	});

	$('#remove_topic').click(function() {
		if (document.getElementById("topic").getElementsByClassName("topic_addition").length > 0) {
			var field_length = document.getElementById("topic").getElementsByClassName("topic_addition").length;
			$(".topic_addition")[field_length - 1].remove();
		}
		return false;
	});

	$('#add_geographic').click(function() {
		$("#geographic").append('<input id="item_subject__geographic_" class="geographic_addition field_addition" type="text" style="width:600px;" name="item[subject][][geographic][]">');
		return false;
	});

	$('#remove_geographic').click(function() {
		if (document.getElementById("geographic").getElementsByClassName("geographic_addition").length > 0) {
			var field_length = document.getElementById("geographic").getElementsByClassName("geographic_addition").length;
			$(".geographic_addition")[field_length - 1].remove();
		}
		return false;
	});

	$('#add_temporal').click(function() {
		$("#temporal").append('<input id="item_subject__temporal_" class="temporal_addition field_addition" type="text" style="width:600px;" name="item[subject][][temporal][]">');
		return false;
	});

	$('#remove_temporal').click(function() {
		if (document.getElementById("temporal").getElementsByClassName("temporal_addition").length > 0) {
			var field_length = document.getElementById("temporal").getElementsByClassName("temporal_addition").length;
			$(".temporal_addition")[field_length - 1].remove();
		}
		return false;
	});
	
	//name
	$('#add_subject_name').click(function() {
		document.getElementById('subject_name_wrap').className = 'subject_name_wrap';
		$("#subject_name").append('<div class="subject_name_wrap subject_name_addition"><label for="item_name_part">Name part</label><div class="field"><input type="text" style="width:600px;" name="item[subject][][name][][name_part]" id="item_subject__name__name_part"></div>' +
														'<label for="item_affiliation">Affiliation</label><div class="field"><input type="text" style="width:600px;" name="item[subject][][name][][affiliation]" id="item_subject__name__affiliation"></div>');
		return false;
	});

	$('#remove_subject_name').click(function() {
		if (document.getElementById("subject_name").getElementsByClassName("subject_name_addition").length > 0) {
			var field_length = document.getElementById("subject_name").getElementsByClassName("subject_name_addition").length;
			$(".subject_name_addition")[field_length - 1].remove();
			if (field_length == 1) {
				document.getElementById('subject_name_wrap').removeAttribute("class");
			}
		}
		return false;
	});
	//end name
	
	$('#add_date_other').click(function() {
		$("#date_other").append('<input id="item_origin_info__date_other_" class="date_other_addition field_addition" type="text" style="width:600px;" name="item[origin_info][][date_other][]">');
		return false;
	});

	$('#remove_date_other').click(function() {
		if (document.getElementById("date_other").getElementsByClassName("date_other_addition").length > 0) {
			var field_length = document.getElementById("date_other").getElementsByClassName("date_other_addition").length;
			$(".date_other_addition")[field_length - 1].remove();
		}
		return false;
	});
	
	$('#add_name_part').click(function() {
		$("#name_part").append('<input id="item_name__name_part_" class="name_part_addition field_addition" type="text" style="width:600px;" name="item[name][][name_part][]">');
		return false;
	});

	$('#remove_name_part').click(function() {
		if (document.getElementById("name_part").getElementsByClassName("name_part_addition").length > 0) {
			var field_length = document.getElementById("name_part").getElementsByClassName("name_part_addition").length;
			$(".name_part_addition")[field_length - 1].remove();
		}
		return false;
	});

	$('#add_genre').click(function() {
		//$("#genre").append('<input id="item_genre_" class="genre_addition field_addition" type="text" style="width:600px;" name="item[genre][]">');
		$("#genre").append('<select style="width:300px;" name="item[genre][]" id="item_genre_" class="genre_addition field_addition"><option value=""></option><option value="Albums">Albums/Scrapbooks</option>' +
											 '<option value="Books">Books</option><option value="Cards">Postcards/Cards</option><option value="Correspondence">Letters/Correspondence</option>' +
											 '<option value="Documents">Documents (other)</option><option value="Drawings">Drawings</option><option value="Ephemera">Ephemera</option>' +
											 '<option value="Manuscripts">Manuscripts</option><option value="Maps">Maps/Atlases</option><option value="Motion pictures">Film/Video</option>' +
											 '<option value="Music">Music (recordings)</option><option value="Musical notation">Sheet music</option><option value="Newspapers">Newspapers</option>' +
											 '<option value="Objects">Objects/Artifacts</option><option value="Paintings">Paintings</option><option value="Periodicals">Periodicals</option>' +
											 '<option value="Photographs">Photographs</option><option value="Posters">Posters</option><option value="Prints">Prints (other)</option>' +
											 '<option value="Sound recordings">Audio recordings (nonmusical)</option></select>');
		return false;
	});

	$('#remove_genre').click(function() {
		if (document.getElementById("genre").getElementsByClassName("genre_addition").length > 0) {
			var field_length = document.getElementById("genre").getElementsByClassName("genre_addition").length;
			$(".genre_addition")[field_length - 1].remove();
		}
		return false;
	});

	$('#add_title').click(function() {
		document.getElementById('title_wrap').className = 'title_wrap';
		$("#title_info").append('<div class="title_wrap title_addition"><label for="item_title">Title</label><div class="field"><input type="text" style="width:600px;" name="item[title_info][][title]" id="item_title_info__title"></div>' +
														'<label for="item_sub_title">Sub title</label><div class="field"><input type="text" style="width:600px;" name="item[title_info][][sub_title]" id="item_title_info__sub_title"></div>' +
														'<label for="item_non_sort">Non sort</label><div class="field"><input type="text" style="width:600px;" name="item[title_info][][non_sort]" id="item_title_info__non_sort"></div></div>');
		return false;
	});

	$('#remove_title').click(function() {
		if (document.getElementById("title_info").getElementsByClassName("title_addition").length > 0) {
			var field_length = document.getElementById("title_info").getElementsByClassName("title_addition").length;
			$(".title_addition")[field_length - 1].remove();
			if (field_length == 1) {
				document.getElementById('title_wrap').removeAttribute("class");
			}
		}
		return false;
	});
	
	$('#add_note').click(function() {
		document.getElementById('note_wrap').className = 'note_wrap';
		$("#note").append('<div class="note_wrap note_addition"><label for="item_note">Note</label><div class="field"><input type="text" style="width:600px;" name="item[additional_note][]" id="item_additional_note_"></div>' +
											'<label for="item_type">Type</label><div class="field"><input type="text" style="width:600px;" name="item[additional_note_type][]" id="item_additional_note_type_"></div></div>');
		return false;
	});
	
	$('#remove_note').click(function() {
		if (document.getElementById("note").getElementsByClassName("note_addition").length > 0) {
			var field_length = document.getElementById("note").getElementsByClassName("note_addition").length;
			$(".note_addition")[field_length - 1].remove();
			if (field_length == 1) {
				document.getElementById('note_wrap').removeAttribute("class");
			}
		}
		return false;
	});
});
