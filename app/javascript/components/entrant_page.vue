<template>
  <div id="entrant_form">
    <h1 class="page-title">{{competition.name}}</h1>

    <p>Enter your details to win!</p>

    <form name="entry">
      <div v-if="completed">
        <p>Thank you for entering our competition!</p>
      </div>
      <div v-else>
        <div id="error_explanation" v-if="Object.keys(field_errors).length > 0">
          Sorry, ther was a problem saving your entry:
          <ul>
            <li v-for="(error_messages, field) in field_errors" :key="field">
              {{field}}:
              <span v-for="message in error_messages">{{message}}</span>
            </li>
          </ul>
        </div>

        <p v-if="competition.requires_entry_name">
          <label for="name">Name</label>
          <input id="name" name="name" v-model="entry.name">
        </p>

        <p>
          <label for="email">Email</label>
          <input id="email" name="email" v-model="entry.email">
        </p>

        <input type="submit" v-on:click.prevent="submit" value="Enter!">
      </div>
    </form>
  </div>
</template>

<script>
export default {
  props: { competition: { type: Object } },
  data() {
    return {
      entry: { name: null, email: null },
      completed: false,
      field_errors: {},
    };
  },
  methods: {
    submit() {
      const self = this;

      this.$http.post('/entries', { entry: { ...this.entry, competition_id: this.competition.id } })
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
};
</script>
