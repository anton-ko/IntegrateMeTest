<template>
  <div :class="`alert alert--error${shaking_class}`">
    <div class="alert__inner">
      Please, enter your MailChimp API key to activate email subscriptions
    </div>

    <form id="api_key_form" class="alert__form api_key_form">
      <div class="l-horizontal">
        <input type="text" class="input api_key_form__input l-grow-1" title="MailChimp API key"
           v-model="api_key" :placeholder="placeholder" :disabled="in_progress" />

        <button id="save_api_key" class="btn btn--warning" v-on:click.prevent="save_api_key" :disabled="in_progress">
          Save
        </button>
      </div>
      <div v-if="error_messages.length > 0" class="alert__form__errors">
        <div v-for="(error_message, index) in error_messages" :key="`err-${index}`">
         {{ error_message }}
        </div>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  props: ['set_api_key', 'shaking'],
  data() {
    return {
      api_key: null,
      in_progress: false,
      error_messages: [],
    };
  },
  computed: {
    placeholder() { return this.set_api_key || '********************************-us00'; },
    shaking_class() { return this.shaking ? ' shake-enter-active' : ''; },
  },
  methods: {
    request_api_key() {
      this.api_key_requested = true;
    },
    save_api_key() {
      this.error_messages = [];
      if (!this.api_key) {
        this.$emit('api_key_set', null);
        return;
      }

      this.in_progress = true;

      this.$http.put('/account-settings', { account: { mailchimp_key: this.api_key } })
        .then((response) => {
          this.in_progress = false;
          if (response.data.success) {
            this.error_messages = [];
            this.$emit('api_key_set', response.data.data.mailchimp_key);
          } else {
            this.error_messages = response.data.errors;
          }
        })
        .catch((error) => {
          this.in_progress = false;
          alert('ERROR!');
          console.log(error);
        });
    },
  },
};
</script>
