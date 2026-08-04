<template lang="html">
  <div>
    <table class="table table-bordered">
      <tr>
        <td class="ide-button-tabbing" role="group" v-for="button in buttons">
            <post-button v-bind:bus="bus" v-bind:button="button"></post-button>
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
import PostButton from "./post_button.vue"

export default {
  data () {
    return {
    }
  },
  computed: {},
  mounted() {
    this.$nextTick(function(){
    });
  },
  methods: {},
  components: {
    PostButton
  },
  props: ["bus", "buttons"]
}
</script>

<style lang="css">
</style>
