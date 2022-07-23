enum JobsEnum {
  SINCRONIZAR_RESPOSTAS('SincronizarRespostas'),
  FINALIZAR_PROVA('FinalizarProvasPendentes'),
  REMOVER_PROVAS_EXPIRADAS('RemocaoProvasExpiradas');

  const JobsEnum(this.taskName);

  final String taskName;

  static JobsEnum? parse(String task) {
    for (var job in JobsEnum.values) {
      if (task == job.taskName) {
        return job;
      }
    }
  }
}
