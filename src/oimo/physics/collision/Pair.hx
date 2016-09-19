package oimo.physics.collision;
import oimo.m.M;
import oimo.physics.collision.broadphase.ProxyPair;
import oimo.physics.collision.PairLink;
import oimo.physics.dynamics.Component;
import oimo.physics.dynamics.contact.Manifold;

/**
 * Cached overlapping component pairs.
 */
@:expose("OIMO.Pair")
class Pair {
	public var _next:Pair;
	public var _prev:Pair;
	public var _c1:Component;
	public var _c2:Component;
	public var _link1:PairLink;
	public var _link2:PairLink;
	public var _manifold:Manifold;

	public var _persistent:Bool;

	public function new() {
		_link1 = new PairLink();
		_link2 = new PairLink();
		_manifold = new Manifold();
		_persistent = false;
	}

	public function _setFromProxyPair(proxyPair:ProxyPair):Void {
		_c1 = proxyPair._p1._component;
		_c2 = proxyPair._p2._component;
		attachLinks();
	}

	public function _clear():Void {
		detachLinks();
		_c1 = null;
		_c2 = null;
	}

	@:extern
	inline function attachLinks():Void {
		M.list_push(_c1._pairLink, _c1._pairLinkLast, _prev, _next, _link1);
		M.list_push(_c2._pairLink, _c2._pairLinkLast, _prev, _next, _link2);
		_c1._numPairs++;
		_c2._numPairs++;
		_link1._theOther = _c2;
		_link2._theOther = _c1;
		_link1._pair = this;
		_link2._pair = this;
	}

	@:extern
	inline function detachLinks():Void {
		M.list_remove(_c1._pairLink, _c1._pairLinkLast, _prev, _next, _link1);
		M.list_remove(_c2._pairLink, _c2._pairLinkLast, _prev, _next, _link2);
		_c1._numPairs--;
		_c2._numPairs--;
		_link1._theOther = null;
		_link2._theOther = null;
		_link1._pair = null;
		_link2._pair = null;
	}

}
