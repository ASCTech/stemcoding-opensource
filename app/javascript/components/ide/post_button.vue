<template lang="html">
  <a
      type="button"
      v-bind:id="button.text.toSnakeCase()"
      v-bind:class="'btn btn-block border ' + button.class"
      @click="buttonAction"
    >
      {{button.text}}
  </a>
</template>

<script>
export default {
  data () {
    return {}
  },
  computed: {},
  mounted: function () {
    this.$nextTick(function() {});
  },
  methods: {
    composeAction(){
      return {
        text: this.button.text,
        no_further_query: this.button.no_further_query,
        post_url: this.button.post_url,
        split_action_url: this.button.split_action_url,
        redirect_url: this.button.redirect_url,
        new_window: this.button.new_window,
        params: this.button.params
      };
    },
    buttonAction: function(){
      this.bus.$emit('post-button', this.composeAction());
    }
  },
  components: {},
  props: ["button", "bus"]
}
</script>

<style lang="css">
</style>
