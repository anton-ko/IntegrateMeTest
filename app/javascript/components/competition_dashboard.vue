<template>
  <div>
    <div class="l-center">
      <transition name="fade">
        <api-key-fetcher v-if="api_key_requested"
          :set_api_key="api_key" v-on:api_key_set="set_api_key"
          :shaking="this.api_key_shaking"/>
      </transition>
    </div>

    <ul class="competitions" v-if="competitions.length > 0">
      <competition v-for="competition in competitions" :competition="competition" :key="competition.id"
        v-on:request_api_key="request_api_key" />
    </ul>
  </div>
</template>

<script>
import ApiKeyFetcher from 'components/api_key_fetcher';
import Competition from 'components/competition';

export default {
  props: { competitions: { type: Array }, saved_api_key: { type: String } },
  components: { 'api-key-fetcher': ApiKeyFetcher, competition: Competition },
  data() {
    return {
      api_key_requested: false,
      api_key_shaking: false,
      api_key: this.saved_api_key || '********************************-us00',
    };
  },
  methods: {
    request_api_key() {
      if (this.api_key_requested) {
        this.shake_api_key();
      } else {
        this.api_key_requested = true;
      }
    },
    set_api_key(apiKey) {
      this.api_key = apiKey;
      this.api_key_requested = false;
    },
    shake_api_key() {
      this.api_key_shaking = true;
      setTimeout(() => { this.api_key_shaking = false; }, 1200);
    },
  },
};
</script>
