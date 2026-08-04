<template>
  <div>
    <navbar v-on:create-tab="createTab" v-bind:tabs="tabs"></navbar>
    <tab-container v-bind:tabs="tabs"></tab-container>
    <button-container v-bind:bus="bus" v-bind:buttons="buttons"></button-container>
  </div>
</template>

<script>
import Navbar from './navbar.vue'
import TabContainer from './tab_container.vue'
import ButtonContainer from "./button_container.vue"
import Vue from 'vue'

var bus = new Vue();

export default {
  data: function() {
    return {
      tabs: [],
      activeTab: {},
      buttons: [],
      bus: bus
    }
  },
  components: {
    Navbar,
    TabContainer,
    ButtonContainer
  },
  methods: {
    setActive(tab) {
        var self = this;
        tab.isActive = true;
        this.activeTab = tab;
        this.tabs.forEach(function (tab) {
            if (tab.id !== self.activeTab.id) { tab.isActive = false;}
        });
    },
    hexEncode(str){
      var hex, i;
      var result = "";
      for (i=0; i<str.length; i++) {
          hex = str.charCodeAt(i).toString(16);
          result += ("000"+hex).slice(-4);
      }
      return result
    },
    createTab() {
      var tid = this.tabs.length;
      var text = "file"+tid+".js";
      var newTab = {
        name: text,
        id: tid,
        content: "",
        editor: {},
        isActive: true
      }
      this.tabs.push(newTab)
      this.setActive(newTab)
    },
    getEditorContent(){
      var editors = [];

      for(var i = 0; i < this.tabs.length; ++i){
        var filename = this.tabs[i].name;
        var content = this.tabs[i].editor.getValue();
        editors.push({
          filename: filename,
          content: content
        });
      }
      return editors;
    },
    postCode(e) {
      var editors = this.getEditorContent();
      var requests = { ids: [], posts: [] };

      for(var i = 0; i < editors.length; ++i){
        var hexData = this.hexEncode(editors[i].content);
        var filename = editors[i].filename;
        requests.posts.push($.post(e.post_url, {name: filename, content: hexData}, function(data){
          if(data.id != null){
            requests.ids.push(data.id)
          }
        }));
      }

      $.when.apply(this, requests.posts).done(function(){
        var ids = requests.ids.join("-");
        var params = {};
        $.extend(params, e.params, {ids: ids});

        if(e.no_further_query){
          var url = e.split_action_url + "?" + $.param(params);

          if(e.new_window) window.open(url);
          else window.location = url;
        }else {

          $.get(e.split_action_url, params, function( data ) {
            var url = e.redirect_url + "?query=" + encodeURIComponent(data.query);

            if(e.new_window) window.open(url);
            else window.location = url;
          });
        }
      });
    },
    loadButtons(obj){
      this.buttons = $.parseJSON(obj);
    },
    loadFiles(obj){
      var myFiles = $.parseJSON(obj);

// sort by filename
    myFiles.sort(function(a, b){
    var nameA=a.filename.toLowerCase(), nameB=b.filename.toLowerCase()
    if (nameA < nameB) //sort string ascending
        return -1 
    if (nameA > nameB)
        return 1
    return 0 //default return value (no sorting)
})      

      for(var i = 0; i < myFiles.length; ++i){
        var filename = myFiles[i].filename;
        var content = myFiles[i].content;
        var newTab = {
          name: filename,
          content: content,
          editor: {},
          id: this.tabs.length,
          isActive: true
        };
        this.tabs.push(newTab)
        if(this.tabs.length > 0){
          this.setActive(this.tabs[0]);
        }
      }
    }
  },
  mounted() {
    this.loadButtons(atob(this.buttonsIn));
    this.loadFiles(atob(this.filesIn));
    this.$nextTick(function() {});
  },
  created() {
    bus.$on('post-button', function(e){
      this.postCode(e);
    }.bind(this));
  },
  beforeCreate() {},
  props: ['buttons-in', 'files-in']
}
</script>
