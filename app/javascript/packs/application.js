import Vue from 'vue/dist/vue.esm';
import Axios from 'axios';

import EntrantPage from '../components/entrant_page.vue';

const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
Axios.defaults.headers.common['X-CSRF-Token'] = token;
Axios.defaults.headers.common.Accept = 'application/json';

Vue.prototype.$http = Axios;

Vue.component('entrant-page', EntrantPage);

document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('competition-app');

  if (element !== undefined) {
    const app = new Vue({
      el: element,
      components: { EntrantPage },
    });
  }
});
