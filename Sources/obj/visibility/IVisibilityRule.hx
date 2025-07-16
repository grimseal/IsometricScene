package obj.visibility;

interface IVisibilityRule {
	public function apply(cell:Cell, grid:IsoGrid):Bool;
}
