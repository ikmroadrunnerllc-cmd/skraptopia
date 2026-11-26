class_name DoodleRecognizer
extends RefCounted

const N := 64
const SIZE := 250.0
const TILT := deg_to_rad(20.0)
const HALF_DIAG := 0.5 * SIZE * 1.4142135
const START_POINTS := 16


static func templates(strokes: Array) -> Array[PackedVector2Array]:
	var out: Array[PackedVector2Array] = []
	if strokes.size() == 1 and _closed(strokes[0]):
		var loop: PackedVector2Array = strokes[0].slice(0, -1)
		for k in START_POINTS:
			var shift := k * loop.size() / START_POINTS
			var s := loop.slice(shift) + loop.slice(0, shift)
			s.append(s[0])
			var r := s.duplicate()
			r.reverse()
			out.append(normalize(s))
			out.append(normalize(r))
		return out
	for order in _permutations(range(strokes.size())):
		for mask in 1 << strokes.size():
			var joined := PackedVector2Array()
			for k in order.size():
				var s: PackedVector2Array = strokes[order[k]].duplicate()
				if mask & (1 << k):
					s.reverse()
				joined.append_array(s)
			out.append(normalize(joined))
	return out


static func best(points: PackedVector2Array, shapes: Dictionary) -> Dictionary:
	var result := {"id": &"", "score": 0.0}
	if points.size() < 2:
		return result
	var c := normalize(points)
	for id in shapes:
		for t: PackedVector2Array in shapes[id]:
			var s := score(c, t)
			if s > result.score:
				result = {"id": id, "score": s}
	return result


static func score(a: PackedVector2Array, b: PackedVector2Array) -> float:
	var phi := 0.5 * (sqrt(5.0) - 1.0)
	var lo := -TILT
	var hi := TILT
	var x1 := phi * lo + (1.0 - phi) * hi
	var x2 := (1.0 - phi) * lo + phi * hi
	var f1 := _distance(a, b, x1)
	var f2 := _distance(a, b, x2)
	while hi - lo > deg_to_rad(2.0):
		if f1 < f2:
			hi = x2
			x2 = x1
			f2 = f1
			x1 = phi * lo + (1.0 - phi) * hi
			f1 = _distance(a, b, x1)
		else:
			lo = x1
			x1 = x2
			f1 = f2
			x2 = (1.0 - phi) * lo + phi * hi
			f2 = _distance(a, b, x2)
	return maxf(0.0, 1.0 - minf(f1, f2) / HALF_DIAG)


static func normalize(points: PackedVector2Array) -> PackedVector2Array:
	var pts := _resample(points)
	var c := Vector2.ZERO
	for p in pts:
		c += p
	c /= pts.size()
	var r := Rect2(pts[0] - c, Vector2.ZERO)
	for p in pts:
		r = r.expand(p - c)
	var k := SIZE / maxf(maxf(r.size.x, r.size.y), 0.001)
	for i in pts.size():
		pts[i] = (pts[i] - c) * k
	return pts


static func _resample(points: PackedVector2Array) -> PackedVector2Array:
	var total := 0.0
	for i in range(1, points.size()):
		total += points[i - 1].distance_to(points[i])
	var interval := total / (N - 1)
	var src := points.duplicate()
	var out := PackedVector2Array([src[0]])
	var acc := 0.0
	var i := 1
	while i < src.size() and interval > 0.0:
		var d := src[i - 1].distance_to(src[i])
		if d > 0.0 and acc + d >= interval:
			var q := src[i - 1].lerp(src[i], (interval - acc) / d)
			out.append(q)
			src.insert(i, q)
			acc = 0.0
		else:
			acc += d
		i += 1
	while out.size() < N:
		out.append(src[src.size() - 1])
	out.resize(N)
	return out


static func _distance(a: PackedVector2Array, b: PackedVector2Array, angle: float) -> float:
	var d := 0.0
	for i in N:
		d += a[i].rotated(angle).distance_to(b[i])
	return d / N


static func _closed(s: PackedVector2Array) -> bool:
	return s.size() > 3 and s[0].distance_to(s[s.size() - 1]) < 0.001


static func _permutations(items: Array) -> Array:
	if items.size() <= 1:
		return [items]
	var out := []
	for i in items.size():
		var rest := items.duplicate()
		var first = rest.pop_at(i)
		for p in _permutations(rest):
			out.append([first] + p)
	return out
