<template>
  <v-card>
    <v-card-title>Pedidos de Póliza</v-card-title>

    <v-card-text>
      <!-- Mostrar los pedidos en forma de tarjetas -->
      <div v-if="pedidos.length === 0">No hay pedidos disponibles.</div>
      <div v-for="(pedido, index) in pedidos" :key="index">
        <v-card class="mb-3">
          <v-card-title>
            Cliente: {{ pedido.username }}
          </v-card-title>
          <v-card-title>Agencia: {{ pedido.agency }}</v-card-title>
          <v-card-title>Tipo de Seguro: {{ pedido.insuranceType }}</v-card-title>
          <v-card-title>Tipo de cobertura: {{ pedido.coverageType }}</v-card-title>

          <!-- Icono para eliminar el pedido -->
          <v-card-actions>
            <v-btn icon @click.prevent="deletePedido(index)">
              <v-icon color="red">mdi-delete</v-icon> <!-- Icono de eliminar -->
            </v-btn>
            <!-- Botón para aceptar pedido -->
            <v-btn color="blue" @click.prevent="openDialog(pedido)">Aceptar Pedido</v-btn>
          </v-card-actions>
        </v-card>
      </div>
    </v-card-text>

    <!-- Diálogo para aceptar el pedido -->
    <v-dialog v-model="dialog" max-width="600px">
      <v-form ref="form" >

                <!-- Aquí van los campos del formulario -->
                <v-card>
              <v-card-title><span class="text-h5">{{
                  formTitle
                }}</span></v-card-title>
              <v-card-text  >
                <v-container >
                  <v-row >
                    <v-col cols="12"
                           md="4"
                           sm="6" >
                      <v-select
                        v-model="editedPoliza.id_agencia_seguro"
                        :items="agencias"
                        item-title="nombre"
                        item-value="id"
                        variant="underlined"
                        density="compact"
                        :rules="[rules.required]"
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
                        item-value="id"
                        variant="underlined"
                        density="compact"
                        :rules="[rules.required]"
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
                        item-value="id"
                        :rules="[rules.required]"
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
                                    model-value=3
                                    label="Estado"
                                    readonly
                                    ></v-text-field>
                    </v-col>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-text-field v-model="editedPoliza.monto_total_asegurado"
                                    model-value=0
                                    variant="underlined"
                                    label="Monto Total"
                                    readonly
                                    ></v-text-field>
                    </v-col>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-select
                        v-model="editedPoliza.numero_identidad_cliente"
                        :items="clientes"
                        item-title="nombre"
                        item-value="id"
                        :rules="[rules.required]"
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

  </v-card>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      editedIndex: -1,
      defaultPoliza: {},
      editedPoliza: {},
      operadores: [],

      pedidos: [], // Almacena los pedidos recuperados del local storage
      dialog: false, // Controla la visibilidad del diálogo
      formTitle: 'Aceptar Pedido', // Título del formulario
      agencias: [], // Debes llenar esto con tus datos
      tiposSeguro: [], // Debes llenar esto con tus datos
      tiposCoberturas: [], // Debes llenar esto con tus datos
      clientes: [], // Debes llenar esto con tus datos

      rules: {
        fechaInicioRule: value => !value || (new Date(value) <= new Date(this.editedPoliza.fecha_fin)) || 'La fecha inicial no puede ser mayor que la fecha final.',
        fechaFinRule: value => !value || (new Date(value) >= new Date(this.editedPoliza.fecha_inicio)) || 'La fecha final no puede ser menor que la fecha inicial.',
        primaRule: value => (value >= 100) || 'La prima mensual no puede ser menor que 100.',
        required: value => !!value || 'Este campo es obligatorio',

      }
    };

  },

  created() {
    const storedData = localStorage.getItem('polizaList');
    if (storedData) {
      this.pedidos = JSON.parse(storedData);
    }
  },

  methods: {

    async fetchData (){
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
  nombre: agencia.nombre_agencia_seguro,
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

    deletePedido(index) {
      // Eliminar el pedido del array local
      this.pedidos.splice(index, 1);

      // Actualizar el local storage
      localStorage.setItem('polizaList', JSON.stringify(this.pedidos));

      // Recargar los pedidos para reflejar los cambios en la interfaz
      this.loadPedidos();

      // Opcionalmente, puedes mostrar un mensaje de confirmación o éxito
      alert('Pedido eliminado con éxito.');
    },

    loadPedidos() {
      const storedData = localStorage.getItem('polizaList');
      if (storedData) {
        this.pedidos = JSON.parse(storedData);
      }
    },

    openDialog(pedid,index) {
      // this.editedPoliza = { ...pedido }; // Cargar los datos del pedido en editedPoliza
      this.dialog = true; // Abrir el diálogo
      this.currentIndex = index; // Guarda el índice actual en una propiedad
      

    },

    closeDialog() {
      this.dialog = false; // Cerrar el diálogo
    },



    async save(index) {
      if (!(await this.$refs.form.validate()).valid) {
        alert("HOLA")
        return
      }

        try {
          console.log(this.editedPoliza);

          await axios.post('/postPoliza', this.editedPoliza)
          alert('Póliza creada con éxito')
          this.deletePedido(index)

        } catch (error) {
          console.error('Error creating policy:', error)
          alert('Error al crear la póliza')
        }


      this.close()
      this.fetchData()


    },
    close() {
      this.dialog = false
      this.$nextTick(() => {
        this.editedPoliza = Object.assign({}, this.defaultPoliza)
        this.editedIndex = -1
      })
    },
  },

  mounted() {
    this.fetchData()
  }
}

</script>

<style scoped>
/* Agrega estilos aquí si es necesario */
</style>
