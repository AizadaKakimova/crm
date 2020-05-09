import Vue from 'vue'
import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate'

Vue.use(Vuex)
export const store = new Vuex.Store({
  state: {
    currentUser: {},
    csrf: null,
    signedIn: false,
    currentCity: ''
    
  },
  getters: {
    isAdmin (state) {
      return state.currentUser && state.currentUser.role === 'admin'
    },
    isManager (state) {
      return state.currentUser && state.currentUser.role === 'manager'
    },
    isInstructor (state) {
      return state.currentUser && state.currentUser.role === 'instructor'
    },
    isStudent (state) {
      return state.currentUser && state.currentUser.role === 'user'
    },
    currentUserId (state) {
      return state.currentUser && state.currentUser.id
    },
    isCurrentCity (state) {
      return state.currentCity !=''
    },
    isSuperUser (state) {
      return state.currentUser.super
    },
    getCurrentCity (state) {
      return state.currentCity
    }
  },
  mutations: {
    setCurrentUser (state, {currentUser, csrf}) {
      state.currentUser = currentUser
      state.signedIn = true
      state.csrf = csrf
    },
    setCurrentCity (state, {currentCity}){
      state.currentCity = currentCity
    },
    unsetCurrentUser (state) {
      state.currentUser = {}
      state.signedIn = false
      state.csrf = null
    },
    refresh (state, csrf) {
      state.signedIn = true
      state.csrf = csrf
    }
  },
  plugins: [createPersistedState()]
})

export default store;
