import
  pkg/ecslib

type
  HierarchyPlugin* = ref object

proc build*(plugin: HierarchyPlugin, world: World) =
  discard

