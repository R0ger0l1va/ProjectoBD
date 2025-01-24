<template>
  <h1>LA LISTA DE POLIZAS</h1>
  <v-data-table-server

    :headers="headers"
    :items="polizas"
    :items-length="totalItems"
    :loading="loading"
    item-value="numero_poliza"
    @update:options="fetchData"


  >
    <template v-slot:item.estadoNombre="{value}">
      <v-chip :color="getColorState(value)">
        {{
          value
        }}
      </v-chip>
    </template>
    <template v-slot:item.tipoCoberturaNombre="{value}">
      <v-chip :color="getColorCoberture(value)">
        {{
          value
        }}
      </v-chip>
    </template>
    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title> LISTA DE POLIZAS</v-toolbar-title>
        <v-divider class="mx-4"
                   inset
                   vertical></v-divider>
        <v-spacer></v-spacer>
        <v-dialog v-model="dialog"
                  max-width="500px"
        >
          <template v-slot:activator="{ props }">
            <v-btn
              class="mb-1"
              color="primary"
              dark
              v-bind="props"
            >
              Nueva Poliza
            </v-btn>
          </template>
          <v-form ref="form">
            <v-card>
              <v-card-title><span class="text-h5">{{
                  formTitle
                }}</span></v-card-title>
              <v-card-text>
                <v-container>
                  <v-row>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-select
                        v-model="editedPoliza.id_agencia_seguro"
                        :items="agencias"
                        item-title="nombre"
                        item-value="id"
                        :rules="[rules.required]"

                        variant="underlined"
                        density="compact"
                        label="Agencias Seguro">
                      </v-select>
                    </v-col>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-select
                        v-model="editedPoliza.id_tipo_seguro"
                        :items="tiposSeguro"
                        item-title="nombre"
                        :rules="[rules.required]"

                        item-value="id"
                        variant="underlined"
                        density="compact"
                        label="Tipos Seguro">
                      </v-select>
                    </v-col>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-select
                        v-model="editedPoliza.id_tipo_cobertura"
                        :items="tiposCoberturas"
                        item-title="nombre"
                        :rules="[rules.required]"

                        item-value="id"
                        variant="underlined"
                        density="compact"
                        label="Tipos Cobertura">
                      </v-select>
                    </v-col>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-text-field v-model="editedPoliza.prima_mensual"
                                    variant="underlined"
                                    
                                    label="Prima Mensual"
                                    :rules="[rules.primaRule]"></v-text-field>
                    </v-col>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-text-field v-model="editedPoliza.id_estado_poliza"
                                    variant="underlined"
                                    label="Estado"
                                    :readonly="isCreating"></v-text-field>
                    </v-col>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-text-field v-model="editedPoliza.monto_total_asegurado"
                                    model-value="0"
                                    variant="underlined"
                                    label="Monto Total"
                                    readonly></v-text-field>
                    </v-col>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-select
                        v-model="editedPoliza.numero_identidad_cliente"
                        :items="clientes"
                        item-title="nombre"
                        :rules="[rules.required]"

                        item-value="id"
                        variant="underlined"
                        density="compact"
                        label="Cliente">
                      </v-select>
                    </v-col>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-date-input
                        :rules="[rules.fechaInicioRule]"
                        color="primary"
                        v-model="editedPoliza.fecha_inicio"
                        variant="underlined"
                        label="Fecha Inicio"></v-date-input>
                    </v-col>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-date-input
                        :rules="[rules.fechaFinRule]"
                        color="primary"
                        v-model="editedPoliza.fecha_fin"
                        variant="underlined"
                        label="Fecha Fin"></v-date-input>
                    </v-col>
                  </v-row>
                </v-container>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn
                  color="blue-darken-1"
                  variant="text"
                  @click="close"
                >
                  Cancel
                </v-btn>
                <v-btn
                  color="blue-darken-1"
                  variant="text"
                  @click="save"
                >
                  Save
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-form>

        </v-dialog>
        <v-dialog v-model="dialogDelete"
                  max-width="500px">
          <v-card>
            <v-card-title class="text-h5">Estas Seguro de Eliminar esta Poliza?</v-card-title>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue-darken-1"
                     variant="text"
                     @click="closeDelete">Cancel
              </v-btn>
              <v-btn color="blue-darken-1"
                     variant="text"
                     @click="deleteItemConfirm"
              >OK
              </v-btn>
              <v-spacer></v-spacer>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
    </template>
    <template v-slot:item.actions="{item}">
      <v-icon
        class="me-2"
        size="small"
        @click="editPoliza(item)"
      >
        mdi-pencil
      </v-icon>
      <v-icon
        size="small"
        @click="deletePoliza(item)"


      >
        mdi-delete
      </v-icon>
    </template>
    <template v-slot:no-data>
      <v-btn
        color="primary"
        @click="initialize"
      >
        Reset
      </v-btn>
    </template>
  </v-data-table-server>
</template>
<script> import axios from "axios";

export default {
  name: 'PoliList',
  data() {
    return {

      editedIndex: -1,
      defaultPoliza: {},
      editedPoliza: {},
      polTarget: 0,

      totalItems: 0,


      dialog: false,
      dialogDelete: false,

      polizas: [],
      loading: false,
      agencias: [],
      tiposSeguro: [],
      tiposCoberturas: [],
      clientes: [],
      operadores: [],
      filtro: {
        id_agencia_seguro: '',
        id_tipo_seguro: '',
        id_estado_poliza: 0,
        prima_mensual_minima: 0
      },
      headers: [
        {
          title: 'Agencia',
          align: 'start',
          sortable: true,
          key: "agenciaNombre",

        },
        {title: 'Tipo de Seguro', key: 'tipoSeguroNombre', sortable: true, align: 'end'},
        {title: 'Cobertura', key: 'tipoCoberturaNombre', align: 'end', sortable: true},
        {title: 'Prima Mensual', key: 'prima_mensual', align: 'end', sortable: true},
        {title: 'Estado', key: 'estadoNombre', align: 'end', sortable: true},
        {title: 'Cliente', key: 'clienteNombre', align: 'end', sortable: true},
        {title: 'Fecha de Inicio', key: 'fechaFormateadaInicio', align: 'end', sortable: true},
        {title: 'Fecha de Fin', key: 'fechaFormateadaFin', align: 'end', sortable: true},
        {title: 'Actions', key: 'actions', sortable: false},

      ],
      rules: {
        fechaInicioRule: value => !value || (new Date(value) <= new Date(this.editedPoliza.fecha_fin)) || 'La fecha inicial no puede ser mayor que la fecha final.',
        fechaFinRule: value => !value || (new Date(value) >= new Date(this.editedPoliza.fecha_inicio)) || 'La fecha final no puede ser menor que la fecha inicial.',
        primaRule: value => (value >= 100) || 'La prima mensual no puede ser menor que 100.',
        required: value => !!value || 'Este campo es obligatorio',

      }

    }

  },
  watch: {
    // Observa cambios en las opciones para volver a cargar los datos
    option: {
      handler() {
        this.fetchData();
      },
      deep: true, // Profundidad para observar cambios en objetos
    },
    dialog(val) {
      val || this.close()

    },
    dialogDelete(val) {
      val || this.closeDelete()
    },
  },
  computed: {
    isCreating() {
      return this.editedIndex === -1;
    },


    itemValue() {
      return item => item.numero_poliza;
    },
    formTitle() {
      return this.editedIndex === -1 ? 'New Item' : 'Edit Item'
    },
  },
  methods: {
    async fetchData({page = 1, itemsPerPage = 10, sortBy = []} = {}) {
      this.loading = true;
      try {


        const [polizasRes, agenciasRes, tiposSeguroRes, tiposCoberturaRes, clientesRes] = await Promise.all([
          axios.get('/getAllPolizas'),
          axios.get('/getAllAgencias'),
          axios.get('/getAllTipoSeguros'),
          axios.get('/getAllCoberturas'),
          axios.get('/getAllClientes'),

        ])

        this.polizas = polizasRes.data
        this.totalItems = this.polizas.length; // Actualiza el total de elementos si es necesario
        this.agencias = agenciasRes.data.map(agencia => ({
          id: agencia.id_agencia_seguro,
          nombre: agencia.nombre_agencia_seguro
        }))
        this.tiposSeguro = tiposSeguroRes.data.map(tipo => ({
          id: tipo.id_tipo_seguro,
          nombre: tipo.nombre_tipo_seguro
        }))
        this.tiposCoberturas = tiposCoberturaRes.data.map(cobertura => ({
          id: cobertura.id_tipo_cobertura,
          nombre: cobertura.nombre_tipo_cobertura
        }))
        this.clientes = clientesRes.data.map(cliente => ({
          id: cliente.numero_identidad_cliente,
          nombre: cliente.nombre_cliente
        }))


        // Determinar el orden de clasificación
        // Determinar el orden de clasificación

        const sortKey = sortBy.length ? sortBy[0].key : null; // Obtener la clave de ordenación
        const sortOrder = sortBy.length ? sortBy[0].order : 'asc'; // Obtener el orden (asc o desc)

        console.log(sortKey)
        const {data} = await axios.get('/sortPolizas', {params: {page, itemsPerPage, sortKey, sortOrder}});
        this.totalItems = data.total;
        this.polizas = data.items.map(poliza => ({
          ...poliza,
          agenciaNombre: this.getAgenciaNombre(poliza.id_agencia_seguro),
          tipoSeguroNombre: this.getTipoSeguroNombre(poliza.id_tipo_seguro),
          tipoCoberturaNombre: this.getTipoCoberturaNombre(poliza.id_tipo_cobertura),
          clienteNombre: this.getClienteNombre(poliza.numero_identidad_cliente),
          estadoNombre: this.getEstadoNombre(poliza.id_estado_poliza),
          fechaFormateadaFin: this.formatDate(poliza.fecha_fin),
          fechaFormateadaInicio: this.formatDate(poliza.fecha_inicio)
        }));


        //todo Fetch operadores from session storage
        const token = sessionStorage.getItem('token')
        const userDataKey = axios.get("/profile", {
          headers:{
            Authorization:`Bearer ${token}`
          }
        })
        if (token && (await userDataKey).data.msg.nombre_usuario) {
          this.operadores = [{id: (await userDataKey).data.msg.id_usuario, nombre: (await userDataKey).data.msg.nombre_usuario}]
        }

        if (this.polizas.length > 0) {
          const keys = Object.keys(this.polizas[0]); // Obtener las claves del primer objeto
          this.editedPoliza = Object.assign(Object.fromEntries(keys.map(key => [key, null])), {
            id_estado_poliza: 3,
            monto_total_asegurado: 0
          }); //todo Crear un nuevo objeto con propiedades vacías
          this.defaultPoliza = Object.assign(Object.fromEntries(keys.map(key => [key, null])), {
            id_estado_poliza: 3,
            monto_total_asegurado: 0
          }); // Crear un nuevo objeto con propiedades vacías

          console.log(this.editedPoliza);
        } else {
          console.log('El arreglo de pólizas está vacío.');
        }


      } catch (error) {
        console.error('Error fetching data:', error)
        alert('Error al cargar los datos. Por favor, intente de nuevo.')
      } finally {
        this.loading = false;
      }
    },


    close() {
      this.dialog = false
      this.$nextTick(() => {
        this.editedPoliza = Object.assign({}, this.defaultPoliza)
        this.editedIndex = -1
      })
    },

    closeDelete() {
      this.dialogDelete = false
      this.$nextTick(() => {
        this.editedPoliza = Object.assign({}, this.defaultPoliza)
        this.editedIndex = -1
      })

    },

    async save() {
      if (!(await this.$refs.form.validate()).valid) {
        alert("HOLA")
        return
      }
      if (this.editedIndex > -1) {
        try {
          await axios.put('/actPoliza', this.editedPoliza)

          alert('Póliza modificada con éxito')

        } catch (error) {
          console.error('Error modificando la póliza:', error)
          alert('Error al modificar la póliza')
        }
      } else {

        try {

          await axios.post('/postPoliza', this.editedPoliza)
          alert('Póliza creada con éxito')
        } catch (error) {
          console.error('Error creating policy:', error)
          alert('Error al crear la póliza')
        }

      }
      this.close()
      this.fetchData()


    },

    editPoliza(item) {
      this.editedIndex = this.polizas.indexOf(item)
      this.editedPoliza = Object.assign({}, item)
      this.dialog = true
    },

    deletePoliza(item) {
      this.editedIndex = this.polizas.indexOf(item)
      this.editedPoliza = Object.assign({}, item)
      this.polTarget = this.editedPoliza.numero_poliza
      this.dialogDelete = true
    },

    async deleteItemConfirm() {
      try {
        await axios.delete(`/delPoliza/${this.polTarget}`)
        alert('Póliza eliminada con éxito')
      } catch (error) {
        console.error('Error eliminando la póliza:', error)
        alert('Error al eliminar la póliza')
      }

      this.closeDelete()
      this.fetchData()
    },


    getAgenciaNombre(id) {
      const agencia = this.agencias.find(a => a.id === id)
      return agencia ? agencia.nombre : 'Desconocida'
    },
    getTipoSeguroNombre(id) {
      const tipo = this.tiposSeguro.find(t => t.id === id)
      return tipo ? tipo.nombre : 'Desconocido'
    },
    getTipoCoberturaNombre(id) {
      const cobertura = this.tiposCoberturas.find(c => c.id === id)
      return cobertura ? cobertura.nombre : 'Desconocida'
    },
    getClienteNombre(id) {
      const cliente = this.clientes.find(c => c.id === id)
      return cliente ? cliente.nombre : 'Desconocido'
    },
    getOperadorNombre(id) {
      const operador = this.operadores.find(o => o.id === id)
      return operador ? operador.nombre : 'Desconocido'
    },
    getEstadoNombre(id) {
      let result = '';
      switch (id) {
        case 1:
          result = 'Cancelada'
          break;
        case 2:
          result = 'Vencida'
          break;
        case 3:
          result = 'Activa'
          break;
        default:
          result = 'Desconocido'
          break;
      }
      return result
    },
    getColorState(estadoNombre) {
      let color = '';
      switch (estadoNombre) {
        case 'Activa':

          color = 'green'
          break;
        case 'Vencida':

          color = 'red'
          break;
        case 'Cancelada':

          color = 'orange'
          break;
      }
      return color
    },
    getColorCoberture(tipoCoberturaNombre) {
      let color = '';
      switch (tipoCoberturaNombre) {
        case 'Estandar':

          color = '#cd7f32'
          break;
        case 'Premium':

          color = '#c0c0c0'
          break;
        case 'VIP':

          color = '#ffd700'
          break;
      }
      return color
    },


    formatDate(dateString) {
      const options = {year: 'numeric', month: '2-digit', day: '2-digit'}
      return new Date(dateString).toLocaleDateString(undefined, options)
    }
  },
  mounted() {
    this.fetchData()
  }
}; </script>
