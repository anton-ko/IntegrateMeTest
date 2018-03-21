import Vue from 'vue/dist/vue.esm';
import Axios from 'axios';

const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
Axios.defaults.headers.common['X-CSRF-Token'] = token;
Axios.defaults.headers.common.Accept = 'application/json';

Vue.prototype.$http = Axios;

document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('entrant_page');

  if (element != null) {
    new Vue({ // eslint-disable-line no-new
      el: element,
      data() {
        return {
          competition: JSON.parse(element.dataset.competition),
          entry: { ...JSON.parse(element.dataset.entry) },
          completed: false,
          field_errors: {},
        };
      },
      methods: {
        submit() {
          const self = this;

          this.$http.post('/entries', { entry: this.entry })
            .then((response) => {
              if (response.data.success) {
                self.completed = true;
              } else {
                self.field_errors = response.data.errors;
              }
            })
            .catch((error) => {
              alert('ERROR!');
              console.log(error);
            });
        },
      },
    });
  }
});
