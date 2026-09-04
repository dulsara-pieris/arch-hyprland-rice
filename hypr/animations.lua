-- =========================================================
-- CURVES
-- =========================================================

hl.curve("cinematic", {
        type = "bezier",
        points = {
                { 0.22, 1 },
                { 0.36, 1 }
        }
})

hl.curve("cinematicInOut", {
        type = "bezier",
        points = {
                { 0.65, 0.05 },
                { 0.35, 1 }
        }
})

hl.curve("gentle", {
        type = "bezier",
        points = {
                { 0.25, 0.8 },
                { 0.4, 1 }
        }
})

hl.curve("clean", {
        type = "bezier",
        points = {
                { 0.16, 1 },
                { 0.3, 1 }
        }
})

hl.curve("linear", {
        type = "bezier",
        points = {
                { 0, 0 },
                { 1, 1 }
        }
})

-- =========================================================
-- SPRING
-- =========================================================

hl.curve("softSpring", {
        type = "spring",
        mass = 1,
        stiffness = 210,
        damping = 28
})

-- =========================================================
-- GLOBAL
-- =========================================================

hl.animation({
        leaf = "global",
        enabled = true,
        speed = 10,
        bezier = "default"
})

-- =========================================================
-- WINDOWS
-- =========================================================

hl.animation({
        leaf = "windows",
        enabled = true,
        speed = 4.2,
        spring = "softSpring"
})

hl.animation({
        leaf = "windowsIn",
        enabled = true,
        speed = 4.5,
        bezier = "cinematic",
        style = "popin 92%"
})

hl.animation({
        leaf = "windowsOut",
        enabled = true,
        speed = 3.5,
        bezier = "gentle",
        style = "popin 92%"
})

hl.animation({
        leaf = "windowsMove",
        enabled = true,
        speed = 4.5,
        bezier = "cinematic"
})

-- =========================================================
-- BORDER
-- =========================================================

hl.animation({
        leaf = "border",
        enabled = true,
        speed = 4,
        bezier = "gentle"
})

-- =========================================================
-- FADE
-- =========================================================

hl.animation({
        leaf = "fade",
        enabled = true,
        speed = 3.5,
        bezier = "gentle"
})

hl.animation({
        leaf = "fadeIn",
        enabled = true,
        speed = 3,
        bezier = "gentle"
})

hl.animation({
        leaf = "fadeOut",
        enabled = true,
        speed = 3.5,
        bezier = "clean"
})

-- =========================================================
-- LAYERS
-- =========================================================

hl.animation({
        leaf = "layers",
        enabled = true,
        speed = 4,
        bezier = "cinematic"
})

hl.animation({
        leaf = "layersIn",
        enabled = true,
        speed = 4,
        bezier = "cinematic",
        style = "popin 94%"
})

hl.animation({
        leaf = "layersOut",
        enabled = true,
        speed = 3.5,
        bezier = "gentle",
        style = "popin 94%"
})

-- =========================================================
-- WORKSPACES
-- =========================================================

hl.animation({
        leaf = "workspaces",
        enabled = true,
        speed = 3,
        bezier = "cinematicInOut",
        style = "slide"
})

hl.animation({
        leaf = "workspacesIn",
        enabled = true,
        speed = 3.2,
        bezier = "cinematic",
        style = "slide"
})

hl.animation({
        leaf = "workspacesOut",
        enabled = true,
        speed = 2.8,
        bezier = "gentle",
        style = "slide"
})

-- =========================================================
-- ZOOM
-- =========================================================

hl.animation({
        leaf = "zoomFactor",
        enabled = true,
        speed = 6,
        bezier = "gentle"
})