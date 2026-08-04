<template lang="html">
<div class="tab-content" id="ideTabsContent">
  <div v-for="tab in tabs" role="tabpanel" class="tab-pane" :class="{active:tab.isActive, show:tab.isActive}">
    <ace-editor :tab="tab"></ace-editor>
  </div>
</div>
</template>

<script>
import AceEditor from "./ace_editor.vue"

export default {
  data: function() {
    return {}
  },
  props: ["tabs", "bus"],
  computed: {},
  methods: {},
  components: {
    AceEditor
  }
}
</script>

<style lang="css">
</style>
