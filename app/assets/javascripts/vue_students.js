$(document).on('ready', function() {


////////////////////////////////////////////////
//// Setting up a general ajax method to handle
//// transfer of data between client and server
////////////////////////////////////////////////
function run_ajax2(method, data, link, callback=function(res){students.get_students()}){
  $.ajax({
    method: method,
    data: data,
    url: link,
    success: function(res) {
      students.errors = {};
      callback(res);
    },
    error: function(res) {
      console.log("error");
      students.errors = res.responseJSON;
    }
  })
}

///////////////////////////////////////////////////////
//// A component to create a camp student list item
///////////////////////////////////////////////////////
Vue.component('student-row', {

  template: `
    <li>
      <a v-on:click="remove_record(student)" class="remove">x&nbsp;&nbsp;</a>
      {{ student.last_name }},&nbsp;{{ student.first_name }}
    </li>
  `,

  props: {
    student: Object
  },

  data: function () {
    return {
      camp_id: 0
    }
  },

  created() {
    this.camp_id = $('#camp_id').val();
  },

  methods: {
    remove_record: function(student){
      run_ajax2
    ('DELETE', {student: student}, '/camps/'.concat(this.camp_id, '/students/',student['id'],'.json'));
    }
  }
});


/////////////////////////////////////////////
//// A component for adding a new student
/////////////////////////////////////////////
var new_form = Vue.component('new-student-form', {
  template: '#registration-form-template',

  mounted() {
    // need to reconnect the materialize select javascript 
    $('#registration_student_id').material_select()
  },

  data: function () {
    return {
        camp_id: 0,
        student_id: 0,
        errors: {}
    }
  },

  methods: {
    submitForm: function (x) {
      new_post = {
        camp_id: this.camp_id,
        student_id: this.student_id
      }
      run_ajax2
    ('POST', {student: new_post}, '/registrations.json')
      this.switch_modal()
    }
  },
})



//////////////////////////////////////////
////***  The Vue instance itself  ***////
/////////////////////////////////////////
var students = new Vue({

  el: '#assignments2',

  data: {
    camp_id: 0,
    students: [],
    modal_open: false,
    errors: {}
  },

  created() {
    this.camp_id = $('#camp_id').val();
  },

  methods: {
    switch_modal: function(event){
      this.modal_open = !(this.modal_open);
    },

    get_students: function(){
      run_ajax2
    ('GET', {}, '/camps/'.concat(this.camp_id, '/students.json'), function(res){students.students = res});
    }
  },

  mounted: function(){
    this.get_students();
  }
});

});