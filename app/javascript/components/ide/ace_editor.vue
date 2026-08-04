<template lang="html">
  <div>
    <pre class="square-border ace-content"
         v-bind:id="'editor-' + tab.id"
         style="height: 500px;">
{{tab.content}}
    </pre>
  </div>
</template>

<script>

require('brace')
require('brace/theme/chrome')
require('brace/mode/javascript')

export default {
  data () {
    return {
    }
  },
  computed: {},
  mounted: function () {
    this.$nextTick(function(){
      var aceIde = ace.edit("editor-"+this.tab.id);
      aceIde.getSession().setMode('ace/mode/javascript');
      aceIde.setTheme('ace/theme/chrome');
      aceIde.setOptions({
        maxLines: 100,
        minLines: 25,
        printMargin: false,
      });

      this.tab.editor = aceIde;
    });
  },
  methods: {},
  props: ["tab"],
  components: {}
}
</script>

<style lang="css">
</style>
