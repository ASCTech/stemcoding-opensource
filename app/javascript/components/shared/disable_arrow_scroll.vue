<template lang="html">

</template>

<script>
export default {
  data () {
    return {}
  },
  created() {

var str = '\
window.addEventListener("keydown", function(e) {\n\
// space and arrow keys\n\
if([32, 37, 38, 39, 40].indexOf(e.keyCode) > -1) {\n\
e.preventDefault();\n\
}\n\
}, false);\n\
'
    eval(str);
  }
}
</script>

<style lang="css">
</style>
