<template lang="html">
</template>

<script>
export default {
  data () {
    return {
      p5_files: ""
    }
  },
  methods: {
    loadFiles(obj){
      obj = obj.replace("function setup", "p.setup = function");
      obj = obj.replace("function draw", "p.draw = function");
      eval("var s = function( p ) {\n" + obj + "\n};");
    }
  },
  components: {
  },
  mounted() {
    this.$nextTick(function(){
      eval("var myp5js = new p5(s);");
    });
  },
  created() {
    this.loadFiles(atob(this.filesIn));
  },
  beforeCreate() {
  },
  props: ["files-in"]
}
</script>

<style lang="css">
</style>
