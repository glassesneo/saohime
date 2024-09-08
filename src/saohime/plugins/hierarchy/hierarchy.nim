import
  pkg/ecslib,
  ./components

type
  HierarchyPlugin* = ref object

proc build*(plugin: HierarchyPlugin, world: World) =
  discard

export
  components

