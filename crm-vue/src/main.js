import Vue from 'vue'
import App from './App'
import router from './router'
import VueSweetalert2 from 'vue-sweetalert2'
import Vuelidate from 'vuelidate'
import { store } from './store'
import VueAxios from 'vue-axios'
import VueTheMask from 'vue-the-mask'
import { securedAxiosInstance, plainAxiosInstance } from './backend/axios'
import BootstrapVue from 'bootstrap-vue'
import VAnimateCss from 'v-animate-css'
import { library } from '@fortawesome/fontawesome-svg-core'
import VueSingleSelect from 'vue-single-select'
import vSelect from 'vue-select'
import moment from 'moment'
import VueAWN from 'vue-awesome-notifications'
import VueWow from 'vue-wow'
import vueSmoothScroll from 'vue2-smooth-scroll'
import { faFacebookF, faVk, faInstagram, faYoutube } from '@fortawesome/free-brands-svg-icons'
import { faClock, faTimes, faMapMarkerAlt, faBars, faPen, faAddressCard, faUserPlus,
  faTrash, faCalendarAlt, faUniversity, faMoneyBillAlt, faMedal, faListUl, faFileCsv, faMinusSquare, faBook, faUserNinja, faSignOutAlt, faChalkboardTeacher, faCog, faChartBar, faSearch, faSquareRootAlt, faPlusSquare, faPencilAlt, faUsers, faUserCheck, faUser, faCalendarWeek, faBrain } from '@fortawesome/free-solid-svg-icons'
import { faComment, faEnvelopeOpen, faFileExcel } from '@fortawesome/free-regular-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import carousel from 'vue-owl-carousel'
import * as VueGoogleMaps from 'vue2-google-maps'
import { SchedulePlugin } from '@syncfusion/ej2-vue-schedule';
import 'vue2-timepicker/dist/VueTimepicker.css'
import JsonExcel from 'vue-json-excel'
import FileUpload from 'v-file-upload'

Vue.use(FileUpload)

Vue.component('downloadExcel', JsonExcel)

library.add(faSearch, faPlusSquare, faPencilAlt)
library.add(faFacebookF)
library.add(faVk)
library.add(faYoutube)
library.add(faInstagram)
library.add(faClock)
library.add(faComment, faEnvelopeOpen, faFileExcel)
library.add(faAddressCard, faMedal, faUser, faMapMarkerAlt, faFileCsv, faBars, faPen, faUserCheck, faTimes, faUsers, faUserPlus, faCalendarAlt,
  faTrash, faUniversity, faBrain, faCalendarWeek, faMoneyBillAlt, faListUl, faMinusSquare, faBook, faUserNinja, faSignOutAlt, faChalkboardTeacher, faCog, faSquareRootAlt, faChartBar)
Vue.use(VueAWN, {
  duration: 5000
})
Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.component('vue-single-select', VueSingleSelect)
Vue.component('v-select', vSelect)

Vue.config.productionTip = false
Vue.use(VueGoogleMaps, {
  load: {
    key: 'AIzaSyD88t6yr9nhynCh69KPOxf-yyK3EyR1wkg'
  }
})
Vue.use(BootstrapVue)
Vue.use(VAnimateCss)
Vue.use(VueWow)
Vue.use(Vuelidate)
Vue.use(vueSmoothScroll)
Vue.use(SchedulePlugin)
Vue.use(VueSweetalert2)
Vue.use(VueAxios, {
  secured: securedAxiosInstance,
  plain: plainAxiosInstance
})
Vue.use(carousel)
Vue.use(VueTheMask)
moment.lang('ru')
Vue.filter('formatDate', function (value) {
  if (value) {
    return moment(String(value)).format('DD-MMM-YY')
  }
})
Vue.filter('formatTime', function (value) {
  if (value) {
    return moment(String(value)).format('HH:MM, DD-MMM-YY')
  }
})

new Vue({ // eslint-disable-line no-new
  el: '#app',
  router,
  store,
  securedAxiosInstance,
  plainAxiosInstance,
  components: { App },
  template: '<App/>'
})
