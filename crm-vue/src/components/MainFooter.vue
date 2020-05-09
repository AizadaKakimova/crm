<template>
  <div>
<section>
      <footer class="page-footer pt-md-4 vw-100">
       
      </footer>
</section>
</div>
</template>
<script>
export default{
  name: 'MainFooter',
  data () {
    return {
      notice: '',
      error: '',
      validEmail: '',
      subscribed: false,
      subscription: {
        email: ''
      },
      reg: /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,24}))$/
    }
  },
  methods: {
    isEmailValid: function () {
      return (this.subscription.email === '') ? '' : (this.reg.test(this.subscription.email)) ? 'has-success' : 'has-error'
    },
    subscribe () {
      this.$http.secured.post('/send_subscription', this.subscription)
        .then(response => {
          this.createSuccessful(response)
        })
        .catch(error => { this.setError(error, 'Please, check lines!') })
    },
    createSuccessful (response) {
      this.subscribed = true
      this.notice = 'Спасибо! 😊'
      this.error = ''
    },
    setError (error, text) {
      if (error) {
        console.log(error.stack)
      }
      this.subscribed = true
      this.error = 'Вы уже подписаны 😊'
      this.notice = ''
    }
  }
}
</script>
<style scoped lang='scss'>
  @import '../../src/assets/css/method.css';
  .subscribe {
    display: none;
  }
   #has-error {
    display: none;
  }
  #has-success {
    display: block;
  }
  .has-success {
    border: 4px solid #ddffdd;
    color: black;
  }
  .has-error{
    border: 3px solid #ffdddc;
    color: red;
  }
  .show {
    font-size: 1.5rem;
  }
</style>
