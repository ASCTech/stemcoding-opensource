<template>
<ul id="ideTabs" class="nav nav-tabs" role="tablist">
  <li role="presentation" v-for="tab in tabs" class="nav-item">
    <a
        href="#"
        v-bind:id="tab.name.toSnakeCase()"
        role="tab"
        data-toggle="tab"
        @click.stop.prevent="setActive(tab)"
        :class="{active:tab.isActive}"
        class="nav-link"
      >
        <!-- The name of the tab -->
        {{ tab.name }}
    </a>
  </li>
  <li>
    <button type="button" id="new-tab" class="btn btn-primary" @click="newTabButton">New tab</button>
  </li>
</ul>
</template>

<script>
export default{
  data: function() {
    return {
    }
  },
  props: ["tabs"],
  methods: {
    setActive: function (tab) {
        var self = this;
        tab.isActive = true;
        this.activeTab = tab;
        this.tabs.forEach(function (tab) {
            if (tab.id !== self.activeTab.id) { tab.isActive = false;}
        });
    },
    newTabButton: function(){
      this.$emit("create-tab");
    }
  }
}
</script>
