<template>
  <li class="competition-item">
    <div class="competition-item__main">
      <div class="competition-item__name">
        <a :href="competition.path">{{competition.name}}</a>
      </div>
        <transition>
          <div v-if="!list_selector_shown" class="competition-item__mail_list">
            <template v-if="mailing_list_id">
              Mailing list: <strong>{{mailing_list_name}}</strong>
              <span class="competition-item__mail_list__actions">
                (
                  <a v-on:click.prevent="show_selector" :aria-disabled="request_in_progress" href="#"
                     class="competition-item__link">change</a> |
                  <a :href="mailing_list_url" class="competition-item__link competition-item__link--external"
                      target="_blank">visit</a>
                )
              </span>
            </template>

            <template v-else>
              <a v-on:click.prevent="show_selector" :aria-disabled="request_in_progress" href="#"
                 class="competition-item__link" >Select a mailing list</a>
            </template>
          </div>

          <div v-else class="competition-item__selector">
            <div id="mail_list_form">
              <label for="mailing_list_id">Select a mailing list</label>
              <select :disabled="request_in_progress" v-model="mailing_list_id"
                      id="mailing_list_id" class="select select--inline">
                <option :disabled="request_in_progress"></option>
                <option v-for="list in mailing_lists" :key="list.id" :value="list.id">
                  {{ list.name }}
                </option>
              </select>
              <button v-on:click.prevent="save_mailing_list" :disabled="request_in_progress"
                      class="btn btn--primary btn--inline" >
                Save
              </button>

              <div v-if="error_message">{{error_message}}</div>
            </div>

          </div>
        </transition>
    </div>

    <div class="competition-item__meta">
      <div class="counter counter--right">
        <div class="counter__number">
          {{ competition.entries_count }}
        </div>
        <div class="counter__description">
          {{ competition.entries_count === 1 ? 'entry' : 'entries' }}
        </div>
      </div>
    </div>
  </li>
</template>

<script>
export default {
  props: ['competition'],
  data() {
    return {
      list_selector_shown: false,
      request_in_progress: false,
      mailing_lists: [],
      mailing_list_id: this.competition.mailing_list_id || null,
      mailing_list_name: this.competition.mailing_list_name || null,
      mailing_list_url: this.competition.mailing_list_url || null,
      error_message: null,
    };
  },
  methods: {
    show_selector() {
      if (this.request_in_progress) { return; }
      this.fetch_mailing_lists()
        .then((lists) => {
          this.mailing_lists = lists;
          this.list_selector_shown = true;
        })
        .catch((error) => {
          if (error === 'api_key') {
            this.$emit('request_api_key');
          }
        });
    },
    fetch_mailing_lists() {
      this.request_in_progress = true;
      return new Promise((resolve, reject) => {
        this.$http.get('/mailing-lists')
          .then((response) => {
            this.request_in_progress = false;
            if (response.data.success) {
              resolve(response.data.mailing_lists);
            } else {
              reject(response.data.error);
            }
          })
          .catch((error) => {
            this.request_in_progress = false;
            alert('ERROR!');
            console.log(error);
          });
      });
    },

    save_mailing_list() {
      if (this.request_in_progress) { return; }

      this.update_mailing_list()
        .then((competition) => {
          this.mailing_list_name = competition.mailing_list_name;
          this.mailing_list_url = competition.mailing_list_url;
          this.list_selector_shown = false;
        })
        .catch((error) => {
          this.error_message = error;
        });
    },
    update_mailing_list() {
      this.request_in_progress = true;
      return new Promise((resolve, reject) => {
        const data = { competition: { mailing_list_id: this.mailing_list_id }};
        this.$http.put(`/competitions/${this.competition.id}`, data)
          .then((response) => {
            this.request_in_progress = false;
            if (response.data.success) {
              resolve(response.data.competition);
            } else {
              reject(response.data.error);
            }
          })
          .catch((error) => {
            this.request_in_progress = false;
            reject(error.message);
          });
      });
    },
  },
};
</script>
