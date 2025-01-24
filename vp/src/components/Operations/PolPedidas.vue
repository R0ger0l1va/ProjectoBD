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
      <v-form ref="form">
        <v-card>
          <v-card-title><span class="text-h5">{{ formTitle }}</span></v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <!-- Aquí van los campos del formulario -->
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

                <!-- Resto de campos... -->
                <!-- Puedes agregar más campos aquí según tu formulario original -->

              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue-darken-1" variant="text" @click="closeDialog">Cancelar</v-btn>
            <v-btn color="blue-darken-1" variant="text" @click="save">Guardar</v-btn>
          </v-card-actions>
        </v-card>
      </v-form>
    </v-dialog>

  </v-card>
</template>

<script>
export default {
  data() {
    return {
      pedidos: [], // Almacena los pedidos recuperados del local storage
      dialog: false, // Controla la visibilidad del diálogo
      formTitle: 'Aceptar Pedido', // Título del formulario
      editedPoliza: {
        id_agencia_seguro: null,
        id_tipo_seguro: null,
        id_tipo_cobertura: null,
        prima_mensual: '',
        id_estado_poliza: '',
        monto_total_asegurado: '',
        numero_identidad_cliente: null,
        fecha_inicio: '',
        fecha_fin: ''
      },
      agencias: [], // Debes llenar esto con tus datos
      tiposSeguro: [], // Debes llenar esto con tus datos
      tiposCoberturas: [], // Debes llenar esto con tus datos
      clientes: [] // Debes llenar esto con tus datos
    };
  },

  created() {
    const storedData = localStorage.getItem('polizaList');
    if (storedData) {
      this.pedidos = JSON.parse(storedData);
    }
  },

  methods: {
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

    openDialog(pedido) {
      this.editedPoliza = { ...pedido }; // Cargar los datos del pedido en editedPoliza
      this.dialog = true; // Abrir el diálogo
    },

    closeDialog() {
      this.dialog = false; // Cerrar el diálogo
    },

    save() {
      // Lógica para guardar los cambios (puedes implementarla según tus necesidades)
      console.log('Guardando:', this.editedPoliza);

      // Cerrar el diálogo después de guardar
      this.closeDialog();

      // Aquí podrías agregar lógica adicional para actualizar el estado o enviar datos al servidor.
    }
  }
}
</script>

<style scoped>
/* Agrega estilos aquí si es necesario */
</style>
